//
//  Bullet.swift
//  PlaneDetection
//
//  Created by Eduardo on 27/10/18.
//  Copyright © 2018 Alvaro Royo. All rights reserved.
//

import ARKit


class Bullet : SCNNode{
    
    let velocity: Float = 9
    
        init(camara: ARCamera) {
            super.init()
            
            let scene = SCNScene(named: "Bullet.scn")
            let node = scene?.rootNode.childNode(withName: "bullet", recursively: false)
           
            self.addChildNode(node!)
            
            let shape = SCNPhysicsShape(node: node!, options: nil)
            self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
            self.physicsBody?.isAffectedByGravity = false
            
            self.physicsBody?.categoryBitMask = Collisions.bullet.rawValue
            self.physicsBody?.contactTestBitMask = Collisions.plane.rawValue
            
            let matrix = SCNMatrix4(camara.transform)
            
            let v = -self.velocity
            let dir = SCNVector3(v * matrix.m31,v * matrix.m32 , v * matrix.m33)
            let pos = SCNVector3(x :matrix.m41, y :matrix.m42, z : matrix.m43)
            
            self.physicsBody?.applyForce(dir, asImpulse: true)
            self.position = pos
        }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
