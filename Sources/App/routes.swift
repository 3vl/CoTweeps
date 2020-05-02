import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let coTweepsController = CoTweepsController()
    
    router.get("users", String.parameter, "followers") {
        req in try coTweepsController.followersOf(req)
    }
}
