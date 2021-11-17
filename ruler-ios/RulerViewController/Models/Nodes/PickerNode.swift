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
        let sphereGeometry = SCNTube(innerRadius: 0.05, outerRadius: 0.055, height: 0.001)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.rulerYellow
        outerCircleNode = SCNNode(geometry: sphereGeometry)
        
        // inner dot
        let dotGeometry = SCNSphere(radius: 0.008)
        dotGeometry.firstMaterial?.diffuse.contents = UIColor.rulerYellow
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
        outerCircleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.rulerYellow
        innerDotNode.geometry?.firstMaterial?.diffuse.contents = UIColor.rulerYellow
        
        outerCircleNode.opacity = 1
        innerDotNode.opacity = 1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
