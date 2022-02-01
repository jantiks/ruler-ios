//
//  UserSeenWalkThroughScene.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/20/21.
//

import Foundation

struct UserSeenWalkThroughSceneCommand: CommonCommand {
    
    func execute() {
        UserDefaults.standard.set(true, forKey: "UserHasSeenWalkThroughScene")
    }
}
