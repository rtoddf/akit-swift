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

        node01.geometry = SCNCylinder(radius: 0.05, height: 0.6)
        node01.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node01.geometry?.firstMaterial?.specular.contents = UIColor.white
        node01.position = SCNVector3(0,0,-0.3)
//        node01.eulerAngles = SCNVector3(Float(180.degreesToRadians),0,0)
//        node01.eulerAngles = SCNVector3(0, Float(45.degreesToRadians), 0)
//        node01.eulerAngles = SCNVector3(0, 0, Float(45.degreesToRadians))
        
        self.sceneView.scene.rootNode.addChildNode(node01)
        
        node02.geometry = SCNCylinder(radius: 0.05, height: 0.6)
        node02.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        node02.geometry?.firstMaterial?.specular.contents = UIColor.white
        node02.position = SCNVector3(0,0,0)
        node02.eulerAngles = SCNVector3(0, 0, Float(90.degreesToRadians))
        
        node01.addChildNode(node02)
        
//        let node01 = SCNNode()
//        let node02 = SCNNode()
//        let node03 = SCNNode()
//
//        node01.geometry = SCNPyramid(width: 0.1, height: 0.05, length: 0.1)
//        node01.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
//
//        node02.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        node02.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
//
//        node03.geometry = SCNPlane(width: 0.03, height: 0.06)
//        node03.geometry?.firstMaterial?.diffuse.contents = UIColor.black
//
//        node01.position = SCNVector3(0.0, 0.0, -0.4)
//        node02.position = SCNVector3(0.0, -0.05, 0.0)
//        node03.position = SCNVector3(0.0, -0.02, 0.051)
//        self.sceneView.scene.rootNode.addChildNode(node01)
//        node01.addChildNode(node02)
//        node02.addChildNode(node03)
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

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

