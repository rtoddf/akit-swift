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
//        Floor
//        node01.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//        node01.geometry = SCNCapsule(capRadius: 0.1, height: 0.3)
//        node01.geometry = SCNCone(topRadius: 0.0, bottomRadius: 0.3, height: 0.3)
//        node01.geometry = SCNCylinder(radius: 0.2, height: 0.2)
//        node01.geometry = SCNPlane(width: 0.1, height: 0.1)
//        node01.geometry = SCNPyramid(width: 0.1, height: 0.05, length: 0.1)
//        node01.geometry = SCNSphere(radius: 0.05)
//        node01.geometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.025)
//        node01.geometry = SCNTube(innerRadius: 0.05, outerRadius: 0.1, height: 0.1)
        
        node01.geometry = SCNSphere(radius: 0.05)
        node01.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        node01.geometry?.firstMaterial?.specular.contents = UIColor.white
        node01.eulerAngles = SCNVector3(Float(60.degreesToRadians), 0, 0)
        
//        let x = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let y = randomNumbers(firstNum: 0, secondNum: 0.15)
//        let z = randomNumbers(firstNum: 0, secondNum: -0.3)
        
        // numbers are in meters - 1.0 is one meter. 0.3 is 30 centimeters
        node01.position = SCNVector3(0.0, 0.0, -0.4)
        self.sceneView.scene.rootNode.addChildNode(node01)
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

