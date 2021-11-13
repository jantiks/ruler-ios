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
    private var innerDotNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        
        // outer circle
        let sphereGeometry = SCNTube(innerRadius: 0.08, outerRadius: 0.1, height: 0.001)
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
    
    /// the rotation and position of this node should be the same as the ARPlane's rotation.
//    func updatePosition(_ ) {
//        outerCircleNode.rotation = rotation
//        innerDotNode.rotation = rotation
//    }
    
    func centerAlign() {
        let (min, max) = boundingBox
        let extents = float3(max) - float3(min)
        simdPivot = float4x4(translation: ((extents / 2) + float3(min)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension float4x4 {
    init(translation vector: float3) {
        self.init(float4(1, 0, 0, 0),
                  float4(0, 1, 0, 0),
                  float4(0, 0, 1, 0),
                  float4(vector.x, vector.y, vector.z, 1))
    }
}
