import Vapor
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let coTweepsController = CoTweepsController()
    
    router.get("users", String.parameter, "followers") {
        req in try coTweepsController.followersOf(req).map { view in
            try req.view().render("followers", view)
        }
    }
    
    router.get("test") {req in
        try req.view().render("followers", ["screenName":"Bozo"])
    }

}
