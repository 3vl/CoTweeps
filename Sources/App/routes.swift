import Vapor


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let coTweepsController = CoTweepsController()
    
    router.get("followers", use: coTweepsController.followersOf)
}
