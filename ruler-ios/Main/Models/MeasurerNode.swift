//
//  MeasurerNode.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/13/21.
//

import Foundation
import SceneKit

class MeasurerNode: SCNNode {
    
    private var outerCircleNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        
        addChildNode(outerCircleNode)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
