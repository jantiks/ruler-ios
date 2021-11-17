//
//  MeasurerNode.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/13/21.
//

import Foundation
import SceneKit

class PickerNode: SCNNode {
    
    private var outerCircleNode: SCNNode = SCNNode()
    private var innerDotNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        
        // outer circle
        let sphereGeometry = SCNTube(innerRadius: 0.06, outerRadius: 0.08, height: 0.001)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.white
        outerCircleNode = SCNNode(geometry: sphereGeometry)
        
        // inner dot
        let dotGeometry = SCNSphere(radius: 0.004)
        dotGeometry.firstMaterial?.diffuse.contents = UIColor.white
        innerDotNode = SCNNode(geometry: dotGeometry)
        
        // setting to have the same possition as MeasurereNode
        outerCircleNode.position = position
        innerDotNode.position = position
        
        addChildNode(outerCircleNode)
        addChildNode(innerDotNode)
    }
    
    func disable() {
        outerCircleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        innerDotNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        
        outerCircleNode.opacity = 0.8
        innerDotNode.opacity = 0.8
    }
    
    func enable() {
        outerCircleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        innerDotNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        outerCircleNode.opacity = 1
        innerDotNode.opacity = 1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
