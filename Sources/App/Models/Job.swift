//
//  Job.swift
//  App
//
//  Created by Melvin John on 05/04/2019.
//

import Foundation

struct Job: Codable {

    enum Status: String, Codable {
        case success = "blue"
        case failed = "red"
        case building
        case unknown

        init(fromRawValue: String) {
            self = Status(rawValue: fromRawValue) ?? .unknown
        }

        init(from decoder: Decoder) throws {

            let container = try decoder.singleValueContainer()

            let type: String = (try? container.decode(String.self)) ?? ""

            if type.contains("anime") {
                self = .building
            } else {
                self = .init(fromRawValue: type)
            }

        }
    }

    enum JobCodingKeys: String, CodingKey {
        case name, color, url
    }

    var name: String
    var status: String
    var url: String
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: JobCodingKeys.self)

        name = try container.decode(String.self, forKey: .name).removingPercentEncoding ?? ""

        let jobStatus = try container.decode(Status.self, forKey: .color)

        status = {
            switch jobStatus {
            case .success:
                return "success"
            case .failed:
                return "failed"
            case .building:
                return "building"
            case .unknown:
                return "unknown"
            }
        }()

        url = "http://localhost:8080/api/ios/job/\(name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"

    }

}
