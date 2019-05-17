//
//  ActiveJobs.swift
//  App
//
//  Created by Melvin John on 02/05/2019.
//

import Foundation
import Vapor

struct ActiveJobs: Content {
    var master: Job?
    var releases: [Job]
    var pullRequests: [Job]

    enum ActiveJobsCodingKeys: String, CodingKey {
        case jobs
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: ActiveJobsCodingKeys.self)

        let jobs = try container.decode([Job].self, forKey: .jobs)

        master = nil
        releases = []
        pullRequests = []

        for job in jobs {
            if job.name == "master" {
                master = job
            } else if job.name.starts(with: "PR") {
                pullRequests.append(job)
            } else if job.name.starts(with: "releases") {
                releases.append(job)
            } else {
                continue
            }
        }

    }

}
