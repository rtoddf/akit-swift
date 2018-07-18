import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }
    
    func createPlane(planeAnchor:ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange.withAlphaComponent(0.5)
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        node.eulerAngles = SCNVector3(CGFloat(90.degreesToRadians), 0, 0)
        
//        node.transform = SCNMatrix4MakeRotation(Float(-90.degreesToRadians), 1, 0, 0)
        return node
    }

    // we need to inherit from a delegate to do this - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // an anchor is info
        // it will give us the position, orientation, and size
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let planeNode = createPlane(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // we can reference the childNode planeNode because this is the same node as detected earlier
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        // is this really the best way?? You'd think you would make this global and update that....
        let planeNode = createPlane(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
}

extension Int {
    var degreesToRadians:Double { return Double(self) * .pi/180}
}

