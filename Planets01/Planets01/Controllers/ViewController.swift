import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var planetObjects = [planetaryObject]()
    var planets = [SCNNode]()
    
    let sunRadius:CGFloat = CGFloat(43441.getPlanetRadius)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("sun radius: \(sunRadius)")
        
        // right now, the sun and jupiter are the same size
        let sun = planetaryObject(name: "sun", geometry: SCNSphere(radius: sunRadius), diffuseImage: #imageLiteral(resourceName: "SunDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(0.distanceToSun), 0, -3.0), universeRotationSpeed: 0.rotationAroundTheSun, rotationSpeed: 648.rotationOnAxis)
        let sunNode = createPlanetaryBody(geometry: sun.geometry, diffuse: sun.diffuseImage, specular: sun.specularImage, emission: sun.emissionImage, normal: sun.normalImage, position: sun.position)
        self.sceneView.scene.rootNode.addChildNode(sunNode)

        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: sun.rotationSpeed)
        let forever = SCNAction.repeatForever(action)
        sunNode.runAction(forever)

        let mercury = planetaryObject(name: "mercury", geometry: SCNSphere(radius: CGFloat(1516.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MercuryDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(35.distanceToSun), 0, 0), universeRotationSpeed: 88.rotationAroundTheSun, rotationSpeed: 2112.rotationOnAxis)
        let venus = planetaryObject(name: "venus", geometry: SCNSphere(radius:CGFloat(3760.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "VenusDiffuse"), specularImage: nil, emissionImage: #imageLiteral(resourceName: "VenusSpecular"), normalImage: nil, position: SCNVector3(CGFloat(67.distanceToSun), 0, 0), universeRotationSpeed: 225.rotationAroundTheSun, rotationSpeed: 5832.rotationOnAxis)
        let earth = planetaryObject(name: "earth", geometry: SCNSphere(radius: CGFloat(3959.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "EarthDiffuse"), specularImage: #imageLiteral(resourceName: "EarthSpecular"), emissionImage: #imageLiteral(resourceName: "EarthEmission"), normalImage: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(CGFloat(92.distanceToSun), 0, 0), universeRotationSpeed: 365.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis)
        let mars = planetaryObject(name: "mars", geometry: SCNSphere(radius: CGFloat(2106.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MarsDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(141.distanceToSun), 0, 0), universeRotationSpeed: 687.rotationAroundTheSun, rotationSpeed: 25.rotationOnAxis)
        let jupiter = planetaryObject(name: "jupiter", geometry: SCNSphere(radius: CGFloat(43441.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "JupiterDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(483.distanceToSun), 0, 0), universeRotationSpeed: 4380.rotationAroundTheSun, rotationSpeed: 10.rotationOnAxis)
        
        // don't forget the rings
        let saturn = planetaryObject(name: "saturn", geometry: SCNSphere(radius: CGFloat(36184.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "SaturnDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(890.distanceToSun), 0, 0), universeRotationSpeed: 11000.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis)
        
        let uranus = planetaryObject(name: "uranus", geometry: SCNSphere(radius: CGFloat(15759.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "UranusDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(1784.distanceToSun), 0, 0), universeRotationSpeed: 31000.rotationAroundTheSun, rotationSpeed: 17.rotationOnAxis)

        self.planetObjects.append(mercury)
        self.planetObjects.append(venus)
        self.planetObjects.append(earth)
        self.planetObjects.append(mars)
        self.planetObjects.append(jupiter)
        self.planetObjects.append(saturn)
        self.planetObjects.append(uranus)
        

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
    
    func calculatePlantDistance(originalDistance:CGFloat) -> CGFloat {
        return sunRadius + (originalDistance * 0.01)
    }

}
