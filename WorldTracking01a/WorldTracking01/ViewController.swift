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
        let node01 = SCNNode()
        let node02 = SCNNode()
        let node03 = SCNNode()
//        node01.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//        node01.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
//        node01.geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.3, height: 0.3)
//        node01.geometry = SCNCylinder(radius: 0.2, height: 0.2)
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: 0, y: 0.2))
//        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
//        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
//        path.addLine(to: CGPoint(x: 0.4, y: 0))
//        node01.geometry = SCNShape(path: path, extrusionDepth: 0.2)
        
        node01.geometry = SCNPyramid(width: 0.1, height: 0.05, length: 0.1)
        node01.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
//        node01.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        node02.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node02.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
//        node02.geometry?.firstMaterial?.specular.contents = UIColor.white
        
        node03.geometry = SCNPlane(width: 0.03, height: 0.06)
        node03.geometry?.firstMaterial?.diffuse.contents = UIColor.black
//        node03.geometry?.firstMaterial?.specular.contents = UIColor.white
        
//        let x = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let y = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let z = randomNumbers(firstNum: 0, secondNum: -0.3)
        
        // numbers are in meters - 1.0 is one meter. 0.3 is 30 centimeters
        node01.position = SCNVector3(0.0, 0.0, -0.4)
        node02.position = SCNVector3(0.0, -0.05, 0.0)
        node03.position = SCNVector3(0.0, -0.02, 0.051)
        self.sceneView.scene.rootNode.addChildNode(node01)
        node01.addChildNode(node02)
        node02.addChildNode(node03)
//        self.sceneView.scene.rootNode.addChildNode(node02)
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

