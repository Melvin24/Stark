//
//  ActiveJobsController.swift
//  App
//
//  Created by Melvin John on 02/05/2019.
//

import Foundation
import Vapor


final class ActiveJobsController {

    private var activeJobsURLString = "http://iplayer-hephaestus.bbcdev.net:8080/job/iPlayer%20iOS/api/json"
    
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<ActiveJobs> {

        let res = try req.make(Client.self).get(activeJobsURLString,
                                                headers: authHeader()).flatMap(to: ActiveJobs.self) { response in
                                                    return try response.content.decode(ActiveJobs.self)
        }

        return res
    }

}
