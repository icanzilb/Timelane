//
//  Releases.swift
//  Timelane
//
//  Created by Marin Todorov on 1/26/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import AppKit

struct Release: Codable {
    struct Version: Codable, Comparable, CustomStringConvertible {
        var description: String {
            return "\(major).\(minor).\(patch)"
        }
        
        static func < (lhs: Release.Version, rhs: Release.Version) -> Bool {
            guard lhs.major == rhs.major else { return lhs.major < rhs.major }
            guard lhs.minor == rhs.minor else { return lhs.minor < rhs.minor }
            return lhs.patch < rhs.patch
        }
        
        let major: Int
        let minor: Int
        let patch: Int

        enum DecodingError: Error {
            case invalidVersion
        }

        init(string: String) throws {
            let versionComponents = string.components(separatedBy: ".")
            guard versionComponents.count >= 2 else {
                throw DecodingError.invalidVersion
            }
            let patch = versionComponents.count >= 3 ? Int(versionComponents[2]) : 0
            self.init(major: Int(versionComponents[0]) ?? 0, minor: Int(versionComponents[1]) ?? 0, patch: patch ?? 0)
        }
        
        init(major: Int, minor: Int, patch: Int) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }
    }
    
    let version: Version
    let name: String
    let isPrerelease: Bool
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case version = "tag_name"
        case name
        case isPrerelease = "prerelease"
        case url = "html_url"
    }
        
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let versionString = try values.decode(String.self, forKey: .version)
        version = try Version(string: versionString)
        name = try values.decode(String.self, forKey: .name)
        isPrerelease = try values.decode(Bool.self, forKey: .isPrerelease)
        url = try values.decode(URL.self, forKey: .url)
    }
}

struct Releases {
    func fetch(callback: @escaping (Release)->Void) {
        let currentVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let currentVersion = try! Release.Version(string: currentVersionString)
        
        URLSession.shared.dataTask(with: URL(string: "https://api.github.com/repos/icanzilb/Timelane/releases")!) { (data, response, error) in
            guard let data = data,
                let releases = try? JSONDecoder().decode([Release].self, from: data),
                let latestRelease = releases.first(where: { release -> Bool in
                    return !release.isPrerelease && currentVersion < release.version
                }) else { return }
            callback(latestRelease)
        }.resume()
    }
}
