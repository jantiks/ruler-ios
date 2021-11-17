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
    private var endVector: SCNVector3?
    
    init(startNode: SCNNode, lineNode: SCNNode, textNode: DrawnTextNode) {
        self.startNode = startNode
        self.lineNode = lineNode
        self.textNode = textNode
    }
    
    func setEndNode(_ node: SCNNode, type: MeasurementType, textRotation: SCNVector3) {
        endNode = node
        buildLineWithTextNode(start: startNode.position, end: endNode!.position, type: type, textRotation: textRotation)
    }
    
    /// setting a vector to calculate distance from star node, if there is no endNode yet
    /// - Parameter vector: the center world position, passed from RulerViewController
    func setEndVector(_ vector: SCNVector3) {
        endVector = vector
    }
    
    func getStart() -> SCNNode {
        return startNode
    }
    
    func getEnd() -> SCNNode? {
        return endNode
    }
    
    /// builds a line between given vectors, and puts a distance node in the middle of the line
    /// - Parameters:
    ///   - start: start vector
    ///   - end: end vector
    func buildLineWithTextNode(start: SCNVector3, end: SCNVector3, type: MeasurementType, textRotation: SCNVector3) {
        lineNode.buildLineInTwoPointsWithRotation(from: start, to: end, radius: 0.001, diffuse: UIColor.white)
        textNode.update(pos1: start, pos2: end, type: type, textRotation: textRotation)
    }
    
    /// returnes the distance between start and end nodes, if there is end node, returnes the distance between start and the last center world vector.
    /// - Parameter type: the calculation type
    /// - Returns: distance.
    func getDistance(_ type: MeasurementType) -> Double {
        if let endNode = endNode {
            return startNode.distance(to: endNode.position) * type.getRatioInMeters()
        } else if let endVector = endVector {
            return startNode.distance(to: endVector) * type.getRatioInMeters()
        }
        
        return 0
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
