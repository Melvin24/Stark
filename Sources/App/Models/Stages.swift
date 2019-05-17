//
//  Stages.swift
//  App
//
//  Created by Melvin John on 09/05/2019.
//

import Foundation

struct Stages: Codable {

    struct StagesResponse: Codable {
        var name: String
        var status: String
    }

    var stages: [StagesResponse]

}
