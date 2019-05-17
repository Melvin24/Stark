//
//  BuildDetail.swift
//  App
//
//  Created by Melvin John on 10/05/2019.
//

import Vapor

struct BuildDetail: Content {

    var buildNumber: String
    var buildStatus: String
    var buildStages: [Build.Stages]
    var buildArtifacts: [Artifact]

    
}
