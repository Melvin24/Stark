import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("api/ios/jobs", use: ActiveJobsController().index)
    router.get("api/ios/job", String.parameter, use: JobDetailController().index)
}
