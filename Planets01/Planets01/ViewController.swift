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

        let sun = planetaryObject(name: "sun", geometry: SCNSphere(radius: 0.432), diffuseImage: #imageLiteral(resourceName: "SunDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(0,0,-3.0), rotationSpeed: 8.0, universeRotationSpeed: 0)
        let sunNode = createPlanetaryBody(geometry: sun.geometry, diffuse: sun.diffuseImage, specular: sun.specularImage, emission: sun.emissionImage, normal: sun.normalImage, position: sun.position)
        self.sceneView.scene.rootNode.addChildNode(sunNode)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: sun.rotationSpeed)
        let forever = SCNAction.repeatForever(action)
        sunNode.runAction(forever)
        
        let venus = planetaryObject(name: "venus", geometry: SCNSphere(radius: 0.13760), diffuseImage: #imageLiteral(resourceName: "VenusDiffuse"), specularImage: nil, emissionImage: #imageLiteral(resourceName: "VenusSpecular"), normalImage: nil, position: SCNVector3(0.7,0,0), rotationSpeed: 10.0, universeRotationSpeed: 5.0)
        let earth = planetaryObject(name: "earth", geometry: SCNSphere(radius: 0.13959), diffuseImage: #imageLiteral(resourceName: "EarthDiffuse"), specularImage: #imageLiteral(resourceName: "EarthSpecular"), emissionImage: #imageLiteral(resourceName: "EarthEmission"), normalImage: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(1.2,0,0), rotationSpeed: 14.0, universeRotationSpeed: 8.0)
        self.planetObjects.append(venus)
        self.planetObjects.append(earth)

        for body in self.planetObjects {
            let planet:SCNNode = createPlanetaryBody(geometry: body.geometry, diffuse: body.diffuseImage, specular: body.specularImage, emission: body.emissionImage, normal: body.normalImage, position: body.position)
            
            let universeCenterNode = SCNNode()
            self.sceneView.scene.rootNode.addChildNode(universeCenterNode)
            universeCenterNode.position = sunNode.position
            
            universeCenterNode.addChildNode(planet)
            
            let universePlanetRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.universeRotationSpeed)
            let universePlanetForeverAction = SCNAction.repeatForever(universePlanetRotation)
            universeCenterNode.runAction(universePlanetForeverAction)
            
            let planetCenterNode = SCNNode()
            planetCenterNode.position = body.position
            planet.addChildNode(planetCenterNode)

            let planetAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.rotationSpeed)
            let planetForever = SCNAction.repeatForever(planetAction)
            planet.runAction(planetForever)
        }

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
