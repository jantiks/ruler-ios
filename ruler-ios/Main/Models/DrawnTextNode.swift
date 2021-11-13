//
//  DrawnTextNode.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/13/21.
//

import Foundation
import SceneKit

class DrawnTextNode: SCNNode {
    
    private let backgroundNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        self.addChildNode(backgroundNode)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(pos1: SCNVector3, pos2: SCNVector3, textPosition: SCNVector3? = nil) {
        // making the text
        var point = SCNHelper.getMidpoint(A: pos1, B: pos2)
        let desc = self.getDistanceStringBeween(pos1: pos1, pos2: pos2)
        let text = SCNText(string: desc, extrusionDepth: 0.01)
        text.font = UIFont(name: "HelveticaNeue", size: 8.0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        text.materials = [material]
        geometry = text
        
        updateBackgroundNode()
        point.x -= 0.008
        position = (textPosition == nil) ? point : textPosition!
        scale = SCNVector3(abs(point.x * 0.008), abs(point.y * 0.008), abs(point.z * 0.008))
    }
    
    private func updateBackgroundNode() {
        let minVec = boundingBox.min
        let maxVec = boundingBox.max
        let bound = SCNVector3Make(maxVec.x - minVec.x, maxVec.y - minVec.y, maxVec.z - minVec.z)
        if backgroundNode.geometry == nil {
            let plane = SCNPlane(width: CGFloat(bound.x + 10), height: CGFloat(bound.y + 5))
            plane.cornerRadius = 9
            plane.firstMaterial?.diffuse.contents = UIColor.gray
            plane.firstMaterial?.isDoubleSided = true
            backgroundNode.geometry = plane
        }
        
        backgroundNode.position = SCNVector3(CGFloat(minVec.x) + CGFloat(bound.x) / 2 , CGFloat(minVec.y) + CGFloat(bound.y) / 2, CGFloat(minVec.z))
        backgroundNode.name = "textBackground"
    }
    
    
    private func getDistanceStringBeween(pos1: SCNVector3?, pos2: SCNVector3?) -> String {
        
        if pos1 == nil || pos2 == nil {
            return "0"
        }
        let d = SCNHelper.distance(from: pos1!, to: pos2!)
        
        let sm = d * 100
        let sms = stringValue(v: Float(sm), unit: "sm")
        
        return sms
    }
    /**
     String with float value and unit
     */
    private func stringValue(v: Float, unit: String) -> String {
        let s = String(format: "%.1f %@", v, unit)
        return s
    }
}
