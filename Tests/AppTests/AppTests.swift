import App
import Vapor
import XCTest

final class AppTests: XCTestCase {
    func makeTest(testConfig: (inout Services, inout Config) throws -> ()) throws -> Application  {
        var services = Services.default()
        var config = Config.default()
        
        let router = EngineRouter.default()
        try routes(router)
        services.register(router, as: Router.self)
        
        var env = Environment.testing
        
        try configure(&config, &env, &services)
        try testConfig(&services, &config)

        return  try Application.asyncBoot(config: config, environment: env, services: services).wait()
    }
    
    func testSingleUserFollowers() throws {
        class MockTwitterClient : TwitterClient {
            let eventLoop : EventLoop

            init(_ eventLoop : EventLoop) {
                self.eventLoop = eventLoop
            }
            
            func fetchFollwers(of screenName: String) throws -> EventLoopFuture<Set<Int64>> {
                return eventLoop.future([1,2,3])
            }
            
            func lookupUsers(userIds ids: Set<Int64>) throws -> EventLoopFuture<Set<User>> {
                var result : Set<User> = []
                for id in ids {
                    result.insert(User(id: id, name: "Name \(id)", screenName: "screenName\(id)"))
                }
                return eventLoop.future(result)
            }
        }
        
        let app = try makeTest { (services, config)  in
            services.register(TwitterClient.self) { container in
                MockTwitterClient(container.eventLoop)
            }
            config.prefer(MockTwitterClient.self, for: TwitterClient.self)
        }
        

        let responsder = try app.make(Responder.self)
        
        let request = HTTPRequest(method: .GET, url: URL(string: "/users/aUser/followers")!)
        let response = try responsder.respond(to:  Request(http: request, using: app)).wait();
                
        XCTAssertEqual(HTTPResponseStatus.ok, response.http.status)
        
        guard let data = response.http.body.data else {
            XCTFail("Expected body")
            return
        }
        
        let body = String(decoding: data, as: UTF8.self)
        XCTAssert(body.contains("screenName1"))
        XCTAssert(body.contains("screenName2"))
        XCTAssert(body.contains("screenName3"))
        
        try app.syncShutdownGracefully()
    }

    static let allTests = [
        ("testSingleUserFollowers", testSingleUserFollowers)
    ]
}
