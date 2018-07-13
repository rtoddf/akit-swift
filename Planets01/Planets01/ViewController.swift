import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var planetObjects = [planetaryObject]()
    var planets = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let sun = planetaryObject(name: "sun", geometry: SCNSphere(radius: 0.432), diffuseImage: #imageLiteral(resourceName: "SunDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(0,0,-3.0))
        let sunNode = createPlanetaryBody(geometry: sun.geometry, diffuse: sun.diffuseImage, specular: sun.specularImage, emission: sun.emissionImage, normal: sun.normalImage, position: sun.position)
        self.sceneView.scene.rootNode.addChildNode(sunNode)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sunNode.runAction(forever)
        
        let earth = planetaryObject(name: "earth", geometry: SCNSphere(radius: 0.13959), diffuseImage: #imageLiteral(resourceName: "EarthDiffuse"), specularImage: #imageLiteral(resourceName: "EarthSpecular"), emissionImage: #imageLiteral(resourceName: "EarthEmission"), normalImage: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(1.2,0,0))
        let venus = planetaryObject(name: "venus", geometry: SCNSphere(radius: 0.13760), diffuseImage: #imageLiteral(resourceName: "VenusDiffuse"), specularImage: nil, emissionImage: #imageLiteral(resourceName: "VenusSpecular"), normalImage: nil, position: SCNVector3(0.7,0,0))
        self.planetObjects.append(earth)
        self.planetObjects.append(venus)

        for planet in self.planetObjects {
            let planet:SCNNode = createPlanetaryBody(geometry: planet.geometry, diffuse: planet.diffuseImage, specular: planet.specularImage, emission: planet.emissionImage, normal: planet.normalImage, position: planet.position)
            sunNode.addChildNode(planet)
        }

        let earthParent = SCNNode()
        let venusParent = SCNNode()
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        earthParent.position = sunNode.position
        venusParent.position = sunNode.position
        

//        earthParent.addChildNode(earth)
//        venusParent.addChildNode(venus)
//
//        let earthAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 14)
//        let venusAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
//        let foreverEarth = SCNAction.repeatForever(earthAction)
//        let foreverVenus = SCNAction.repeatForever(venusAction)
//        earthParent.runAction(foreverEarth)
//        venusParent.runAction(foreverVenus)
        
//        let earthMoonParent = SCNNode()
//        self.sceneView.scene.rootNode.addChildNode(earthMoonParent)
//        earthMoonParent.position = earth.position
        
//        let earthMoon = createPlanetaryBody(geometry: SCNSphere(radius: 0.03), diffuse: #imageLiteral(resourceName: "EarthMoonDiffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0.3,0,0))
//        earth.addChildNode(earthMoon)
//
//        let earthMoonAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 2)
//        let foreverEarthMoon = SCNAction.repeatForever(earthMoonAction)
//        earth.runAction(foreverEarthMoon)
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
