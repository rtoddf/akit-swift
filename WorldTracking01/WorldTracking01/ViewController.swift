import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }

    @IBAction func add(_ sender: Any) {
        let node = SCNNode()
//        node.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
//        node.geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.3, height: 0.3)
//        node.geometry = SCNCylinder(radius: 0.2, height: 0.2)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0.2))
        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
        path.addLine(to: CGPoint(x: 0.4, y: 0))
        
        node.geometry = SCNShape(path: path, extrusionDepth: 0.2)
        
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        
//        let x = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let y = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let z = randomNumbers(firstNum: 0, secondNum: -0.3)
        
        // numbers are in meters - 1.0 is one meter. 0.3 is 30 centimeters
        node.position = SCNVector3(0, 0, -0.3)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.restartSession()
    }
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}

