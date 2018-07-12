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
        let sunNode = SCNNode()
        sunNode.geometry = SCNSphere(radius: 0.35)
        sunNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sundiffuse")
        sunNode.position = SCNVector3(0,0,-3.0)
        self.sceneView.scene.rootNode.addChildNode(sunNode)
        
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        earthParent.position = sunNode.position
        venusParent.position = sunNode.position
        
        let earth = createPlanetaryBody(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earthday"), specular: #imageLiteral(resourceName: "Earthspecular"), emission: #imageLiteral(resourceName: "Earthclouds"), normal: #imageLiteral(resourceName: "Earthnormal"), position: SCNVector3(1.2,0,0))
        let venus = createPlanetaryBody(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "VenusDiffuse"), specular: nil, emission: #imageLiteral(resourceName: "VenusSpecular"), normal: nil, position: SCNVector3(0.7,0,0))
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sunNode.runAction(forever)
        
        let earthAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 14)
        let venusAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
        let foreverEarth = SCNAction.repeatForever(earthAction)
        let foreverVenus = SCNAction.repeatForever(venusAction)
        earthParent.runAction(foreverEarth)
        venusParent.runAction(foreverVenus)
        
//        let earthMoonParent = SCNNode()
//        self.sceneView.scene.rootNode.addChildNode(earthMoonParent)
//        earthMoonParent.position = earth.position
        
        let earthMoon = createPlanetaryBody(geometry: SCNSphere(radius: 0.03), diffuse: #imageLiteral(resourceName: "EarthMoonDiffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.3,0,0))
        earth.addChildNode(earthMoon)
        
        let earthMoonAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 2)
        let foreverEarthMoon = SCNAction.repeatForever(earthMoonAction)
        earth.runAction(foreverEarthMoon)
    }
    
    func createPlanetaryBody(geometry:SCNGeometry, diffuse:UIImage, specular:UIImage?, emission:UIImage?, normal:UIImage?, position:SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.geometry = geometry
        node.geometry?.firstMaterial?.diffuse.contents = diffuse
        node.geometry?.firstMaterial?.specular.contents = specular
        node.geometry?.firstMaterial?.emission.contents = emission
        node.geometry?.firstMaterial?.normal.contents = normal
        node.position = position
        return node
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}
