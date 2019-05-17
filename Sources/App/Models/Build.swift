//
//  Build.swift
//  App
//
//  Created by Melvin John on 09/05/2019.
//

import Foundation
import Vapor

struct Build: Content {

    struct Stages: Codable {
        var name: String
        var status: String
        var durationMillis: TimeInterval
    }

    var id: String
    var status: String
    var stages: [Stages]

}
