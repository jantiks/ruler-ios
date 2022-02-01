//
//  SCNHelper.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/13/21.
//

import Foundation
import SceneKit

class SCNHelper {
    static func getMidpoint(A: SCNVector3, B: SCNVector3) -> SCNVector3 {
        let x: Float = (A.x + B.x) / 2
        let y: Float = (A.y + B.y) / 2
        let z: Float = (A.z + B.z) / 2
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    static func distance(from first: SCNVector3, to second: SCNVector3) -> CGFloat {
        let dx = first.x - second.x
        let dy = first.y - second.y
        let dz = first.z - second.z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
}
