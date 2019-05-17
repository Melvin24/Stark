//
//  JobDetailController.swift
//  App
//
//  Created by Melvin John on 05/04/2019.
//

import Vapor

final class JobDetailController {

    private var buildStagesURLPath = "http://iplayer-hephaestus.bbcdev.net:8080/job/iPlayer%20iOS/job/{{jobName}}/wfapi/runs"
    private var buildArtifactURLPath = "http://iplayer-hephaestus.bbcdev.net:8080/job/iPlayer%20iOS/job/{{jobName}}/{{buildNumber}}/wfapi/artifacts"

    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[BuildDetail]> {
        let jobName = try req.parameters.next(String.self)

        let encodedBuildStagesURLPath = buildStagesURLPath.replacingOccurrences(of: "{{jobName}}",
                                                                                with: jobName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")

        let future1 = try req.client().get(encodedBuildStagesURLPath, headers: authHeader())

        let promise = req.eventLoop.newPromise([BuildDetail].self)

        _ = future1.map { response -> [Build] in

            let builds = try response.content.syncDecode([Build].self)

            let artifactFutures: [EventLoopFuture<Response>] = try builds.map { build in

                let encodedBuildArtifactRULPathWithJobName = self.buildArtifactURLPath.replacingOccurrences(of: "{{jobName}}",
                                                                                                            with: jobName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")

                let encodedBuildArtifactRULPath = encodedBuildArtifactRULPathWithJobName.replacingOccurrences(of: "{{buildNumber}}",
                                                                                                              with: build.id)

                return try req.client().get(encodedBuildArtifactRULPath, headers: authHeader())

            }

            _ = artifactFutures.flatten(on: req).map { artifactResponses in

                let buildDetails: [BuildDetail] = try artifactResponses.enumerated().map { (offset, artifactResponse) in

                    let artifacts = try artifactResponse.content.syncDecode([Artifact].self)

                    let buildDetail = BuildDetail(buildNumber: builds[offset].id,
                                                  buildStatus:  builds[offset].status,
                                                  buildStages:  builds[offset].stages,
                                                  buildArtifacts: artifacts)




                    return buildDetail
                }

                promise.succeed(result: buildDetails)
            }

            return builds

        }

        return promise.futureResult

    }

}
