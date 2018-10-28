//
//  Plane.swift
//  PlaneDetection
//
//  Created by Alvaro Royo on 27/10/2018.
//  Copyright © 2018 Alvaro Royo. All rights reserved.
//

import ARKit

class Plane: SCNNode {
    
    override init() {
        super.init()
        
        let scene = SCNScene(named: "ship.scn")
        let node = scene?.rootNode.childNode(withName: "ship", recursively: true)
        self.addChildNode(node!)
        
        //Añadimos fisicas
        let shape = SCNPhysicsShape(node: node!, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        self.physicsBody?.contactTestBitMask = Collisions.bullet.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func face(to cameraOrientation:simd_float4x4) {
        
        var transform = cameraOrientation
        transform.columns.3.x = self.position.x
        transform.columns.3.y = self.position.y
        transform.columns.3.z = self.position.z
        self.transform = SCNMatrix4(transform)
    }
    
}
