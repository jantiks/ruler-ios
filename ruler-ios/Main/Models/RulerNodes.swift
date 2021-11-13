//
//  RulerNodes.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/12/21.
//

import Foundation
import SceneKit

class RulerNodes {
    
    private var startNode: SCNNode
    private var endNode: SCNNode?
    private var lineNode: SCNNode
    private var textNode: DrawnTextNode
    
    init(startNode: SCNNode, lineNode: SCNNode, textNode: DrawnTextNode) {
        self.startNode = startNode
        self.lineNode = lineNode
        self.textNode = textNode
    }
    
    func setEndNode(_ node: SCNNode) {
        endNode = node
        buildLineWithTextNode(start: startNode.position, end: endNode!.position)
    }
    
    func getStart() -> SCNNode {
        return startNode
    }
    
    /// builds a line between given vectors, and puts a distance node in the middle of the line
    /// - Parameters:
    ///   - start: start vector
    ///   - end: end vector
    func buildLineWithTextNode(start: SCNVector3, end: SCNVector3) {
        lineNode.buildLineInTwoPointsWithRotation(from: start, to: end, radius: 0.001, diffuse: UIColor.white)
        textNode.update(pos1: start, pos2: end, textPosition: SCNHelper.getMidpoint(A: start, B: end))
    }
    
    func getDistance(_ type: MeasurementType, to vector: SCNVector3? = nil) -> Double {
        if vector == nil {
            return startNode.distance(to: endNode!.position)
        }
        
        return startNode.distance(to: vector!)
    }
    
    func removeNodes() {
        startNode.removeFromParentNode()
        endNode?.removeFromParentNode()
        lineNode.removeFromParentNode()
        textNode.removeFromParentNode()
    }
    
    /// - Returns: returnes true if both nodes are seted.
    func isComplete() -> Bool {
        return endNode != nil
    }
}
