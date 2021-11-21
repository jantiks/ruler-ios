//
//  DoneCommand.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/20/21.
//

import Foundation

struct DoneCommand: CommonCommand {
    
    private var action: () -> ()
    
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    func execute() {
        action()
    }
}
