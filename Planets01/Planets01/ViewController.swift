import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let node01 = SCNNode()
        node01.geometry = SCNSphere(radius: 0.2)
        node01.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earthday")
        node01.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "Earthspecular")
        node01.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "Earthclouds")
        node01.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "Earthnormal")
        
        node01.position = SCNVector3(0,0,-1.0)
        self.sceneView.scene.rootNode.addChildNode(node01)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        node01.runAction(forever)
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
