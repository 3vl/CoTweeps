import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let coTweepsController = CoTweepsController()
    
    
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("test", use: coTweepsController.followersOf)
    
    router.get("simple") {req throws -> Future<UserCursor> in 
        let client = try req.make(Client.self)
        
        let res = client.get("https://api.twitter.com/1.1/followers/list.json?screen_name=3vl", headers: ["authorization":"Bearer "])
        return res.flatMap { res in
            return try res.content.decode(UserCursor.self)
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
