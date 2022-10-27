//
//  ViewController.swift
//  AR Ruler
//
//  Created by Vlad V on 26.10.2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: ARRaycastQuery.Target.estimatedPlane, alignment: .any) else {
                return
            }
            
            let results = sceneView.session.raycast(query)
            if let hitResult = results.first {
                addDot(at: hitResult)
            }
        }
    }
    
    func addDot(at hitResult : ARRaycastResult){
        let dotGeometry = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        dotGeometry.materials = [dotMaterial]
        
        let node = SCNNode(geometry: dotGeometry)
        node.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                   hitResult.worldTransform.columns.3.y,
                                   hitResult.worldTransform.columns.3.z)

        sceneView.scene.rootNode.addChildNode(node)
    }
}
