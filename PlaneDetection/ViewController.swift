//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Alvaro Royo on 06/10/2018.
//  Copyright © 2018 Alvaro Royo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arview: ARSCNView!
    var plane:Plane!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Si vais a integrar ARKit en una app disponible para iPhones no compatibles teneis que comprobar que sean compatibles antes e ejecutar ARKit o la aplicación petará estrepitosamente. En este caso hemos pedido a las autoridades de Apple que comprueben por nosotros que el dispositivo sea válido.
        //        guard ARWorldTrackingConfiguration.isSupported else {
        //            fatalError("ARKit is not available on this device.")
        //        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical] //Detectamos todos los tipos de planos
        
        arview.session.run(configuration)
        arview.session.delegate = self
        arview.delegate = self
        arview.showsStatistics = true //Enseña en pantalla los recursos que usamos.
        arview.scene.physicsWorld.contactDelegate = self
        
        //Prevenimos que se apague la pantalla ya que el usuario no va a interactuar con ella.
        //OJO!! Si el dispositivo está con el modo ahorro de energia este paso no vale pa' na se apagará igualmente
        //OJO 2!! Esto solo está permitido a aplicaciones de juegos, mapas y audio. Además se requiere que se ponga a false cuando deje de ser necesario. En caso contrario si subis una app a la store sin cumplir estos pasos la rechazarán. 🤨
        UIApplication.shared.isIdleTimerDisabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapScreen))
        self.arview.addGestureRecognizer(tap)
        
        self.plane = Plane()
        self.arview.scene.rootNode.addChildNode(self.plane)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arview.session.pause()
    }
    
    func addNewPlane() {
        
        let plane = Plane()
        plane.position.x = Float.random(in: -1...1)
        plane.position.y = Float.random(in: -1...1)
        plane.position.z = Float.random(in: -1.5 ... -1)
        self.arview.scene.rootNode.addChildNode(plane)
        
    }
    
    @objc func tapScreen() {
        
        guard let camera = self.arview.session.currentFrame?.camera else { return }
        let bulletNode = Bullet(camara: camera)
        self.arview.scene.rootNode.addChildNode(bulletNode)
        
    }
    
    private func startTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        //Como lo usaremos también si la pantalal entra en reposo o segundo plano tenemos que resetear todos los datos de tracking y eliminar medidas y nodos antiguos.
        arview.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

//MARK: - ARSession delegate (Todas las funciones son opcionales)
extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraOrientation = session.currentFrame?.camera.transform
        self.plane.face(to: cameraOrientation!)
    }
    
}

//MARK: - Physics Delegate
extension ViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let c1 = contact.nodeA
        let c2 = contact.nodeB
        
        if c1.physicsBody?.categoryBitMask == Collisions.plane.rawValue || c2.physicsBody?.categoryBitMask == Collisions.plane.rawValue {
            
            //            var node = c1 is Plane ? c1 : c2
            let rootNode = self.arview.scene.rootNode
            rootNode.childNodes.forEach{ $0.removeFromParentNode() }
            
            self.addNewPlane()
            
        }
        
    }
    
}

//MARK: - ARSCNViewDelegate (Todas las funciones son opcionales)
extension ViewController: ARSCNViewDelegate {
    
    //    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //        //Solo queremos las medidas de planos para esta app
    //        guard let planeAnchor = anchor as? ARPlaneAnchor,
    //        let device = sceneView.device //SI DA FALLO FIJAROS QUE ESTAIS EJECUTANDO SOBRE UN DISPOSITIVO REAL
    ////        let device = MTLCreateSystemDefaultDevice() //Si sigue dando error usad esta línea y comentad la anterior.
    //        else { return }
    //
    //        //Creamos el nodo con el plano
    //        let plane = Plane(anchor: planeAnchor, in: device)
    //
    //        node.addChildNode(plane)
    //    }
    //
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //        //El propio dispositivo detecta si el nodo que ya hemos creado ha cambiado de tamaño, posición etc
    //        //Nos manda con esta función los nuevos parámetros para que actualicemos la vista
    //
    //        guard let planeAnchor = anchor as? ARPlaneAnchor,
    //        let plane = node.childNodes.first as? Plane
    //        else { return }
    //
    //        //Actualizamos las medidas del plano a las nuevas
    //        if let planeGeometry = plane.mesh.geometry as? ARSCNPlaneGeometry {
    //            planeGeometry.update(from: planeAnchor.geometry)
    //        }
    //    }
    
}

