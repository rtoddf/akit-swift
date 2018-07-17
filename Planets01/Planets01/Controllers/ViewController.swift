import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBAction func pause(_ sender: Any) {
        if !paused {
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeAllActions()
            }
            self.paused = true
        } else {
            
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                
                for body in planetObjects {
                    if node.name == "universeCenterNodeFor\(body.name)" {
                        let universePlanetRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.universeRotationSpeed)
                        let universePlanetForeverAction = SCNAction.repeatForever(universePlanetRotation)
                        node.runAction(universePlanetForeverAction)
                    } else if node.name == "\(body.name)Object" {
                        let planetAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.rotationSpeed)
                        let planetForever = SCNAction.repeatForever(planetAction)
                        node.runAction(planetForever)
                    } else {
//                        print("not found")
                    }
                }
            }
            
            self.sunNode.runAction(self.sunForever, forKey: "sunAction")
            
            if ((planetInfoView.superview) != nil) {
                planetInfoView.removeFromSuperview()
                nameLabel.removeFromSuperview()
                distanceFromTheSunLabel.removeFromSuperview()
            }

            self.paused = false
        }
        
    }

    let configuration = ARWorldTrackingConfiguration()
    
    var planetObjects = [planetaryObject]()
    var planets = [SCNNode]()
    
    var sunNode = SCNNode()
    var sunAction = SCNAction()
    var sunForever = SCNAction()
    let sunRadius:CGFloat = CGFloat(43441.getPlanetRadius)
    
    var paused:Bool = false
    
    let planetInfoView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.75)
        return view
    }()
    let distanceFromTheSunLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sunPosition = SCNVector3(CGFloat(0.distanceToSun), 0, -3.0)
        setSunNode(position: sunPosition)

        self.planetObjects = setPlanetaryObject()

        for body in self.planetObjects {
            let planet:SCNNode = createPlanetaryBody(name:body.name, geometry: body.geometry, diffuse: body.diffuseImage, specular: body.specularImage, emission: body.emissionImage, normal: body.normalImage, position: body.position)
            
            // why do you need this?
            let tilt = body.axisTilt * .pi/180
            // tilt the planet on it's axis
            planet.eulerAngles = SCNVector3(0, 0, tilt)

            // set the universe center, name the node, add the action
            let universeCenterNode = SCNNode()
            self.sceneView.scene.rootNode.addChildNode(universeCenterNode)
            universeCenterNode.position = sunPosition
            universeCenterNode.name = "universeCenterNodeFor\(body.name)"
            universeCenterNode.addChildNode(planet)
            
            let universePlanetRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.universeRotationSpeed)
            let universePlanetForeverAction = SCNAction.repeatForever(universePlanetRotation)
            universeCenterNode.runAction(universePlanetForeverAction)
            
            let planetCenterNode = SCNNode()
            planetCenterNode.position = body.position
            planetCenterNode.name = "planetCenterNodeFor\(body.name)"
            planet.addChildNode(planetCenterNode)

            let planetAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: body.rotationSpeed)
            let planetForever = SCNAction.repeatForever(planetAction)
            planet.runAction(planetForever)
        }
    }
    
    func setSunNode(position:SCNVector3){
        // right now, the sun and jupiter are the same size
        let sun = planetaryObject(name: "Sun", geometry: SCNSphere(radius: sunRadius), diffuseImage: #imageLiteral(resourceName: "Sundiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: position, universeRotationSpeed: 0.rotationAroundTheSun, rotationSpeed: 648.rotationOnAxis, axisTilt: 7.5)
        self.sunNode = createPlanetaryBody(name: sun.name, geometry: sun.geometry, diffuse: sun.diffuseImage, specular: sun.specularImage, emission: sun.emissionImage, normal: sun.normalImage, position: sun.position)
        self.sceneView.scene.rootNode.addChildNode(self.sunNode)

        let sunTilt = sun.axisTilt * .pi/180
        sunNode.eulerAngles = SCNVector3(0, 0, sunTilt)
        
        self.sunAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: sun.rotationSpeed)
        self.sunForever = SCNAction.repeatForever(self.sunAction)
        sunNode.runAction(self.sunForever, forKey: "sunAction")
    }
    
    func setPlanetaryObject() -> [planetaryObject] {
        let mercury = planetaryObject(name: "Mercury", geometry: SCNSphere(radius: CGFloat(1516.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MercuryDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(35.distanceToSun), 0, 0), universeRotationSpeed: 88.rotationAroundTheSun, rotationSpeed: 2112.rotationOnAxis, axisTilt: 2.11)
        let venus = planetaryObject(name: "Venus", geometry: SCNSphere(radius:CGFloat(3760.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "VenusDiffuse"), specularImage: nil, emissionImage: #imageLiteral(resourceName: "VenusSpecular"), normalImage: nil, position: SCNVector3(CGFloat(67.distanceToSun), 0, 0), universeRotationSpeed: 225.rotationAroundTheSun, rotationSpeed: 5832.rotationOnAxis, axisTilt: 177.3)
        let earth = planetaryObject(name: "Earth", geometry: SCNSphere(radius: CGFloat(3959.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "EarthDiffuse"), specularImage: #imageLiteral(resourceName: "EarthSpecular"), emissionImage: #imageLiteral(resourceName: "EarthEmission"), normalImage: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(CGFloat(92.distanceToSun), 0, 0), universeRotationSpeed: 365.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis, axisTilt: 23.5)
        
        let mars = planetaryObject(name: "Mars", geometry: SCNSphere(radius: CGFloat(2106.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MarsDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(141.distanceToSun), 0, 0), universeRotationSpeed: 687.rotationAroundTheSun, rotationSpeed: 25.rotationOnAxis, axisTilt: 25)
        let jupiter = planetaryObject(name: "Jupiter", geometry: SCNSphere(radius: CGFloat(43441.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "JupiterDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(483.distanceToSun), 0, 0), universeRotationSpeed: 4380.rotationAroundTheSun, rotationSpeed: 10.rotationOnAxis, axisTilt: 3)
        
        // don't forget the rings
        let saturn = planetaryObject(name: "Saturn", geometry: SCNSphere(radius: CGFloat(36184.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "SaturnDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(890.distanceToSun), 0, 0), universeRotationSpeed: 11000.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis, axisTilt: 26.7)
        
        let uranus = planetaryObject(name: "Uranus", geometry: SCNSphere(radius: CGFloat(15759.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "UranusDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(1784.distanceToSun), 0, 0), universeRotationSpeed: 31000.rotationAroundTheSun, rotationSpeed: 17.rotationOnAxis, axisTilt: 23.5)
        let neptune = planetaryObject(name: "Neptune", geometry: SCNSphere(radius: CGFloat(15299.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "NeptuneDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(2800.distanceToSun), 0, 0), universeRotationSpeed: 60225.rotationAroundTheSun, rotationSpeed: 16.rotationOnAxis, axisTilt: 28.32)
        
        self.planetObjects.append(mercury)
        self.planetObjects.append(venus)
        self.planetObjects.append(earth)
        self.planetObjects.append(mars)
        self.planetObjects.append(jupiter)
        self.planetObjects.append(saturn)
        self.planetObjects.append(uranus)
        self.planetObjects.append(neptune)
        
        return planetObjects
    }
    
    func createPlanetaryBody(name:String, geometry:SCNGeometry, diffuse:UIImage, specular:UIImage?, emission:UIImage?, normal:UIImage?, position:SCNVector3) -> SCNNode {
        let node = SCNNode()
        node.name = "\(name)Object"
        node.geometry = geometry
        node.geometry?.firstMaterial?.diffuse.contents = diffuse
        node.geometry?.firstMaterial?.specular.contents = specular
        node.geometry?.firstMaterial?.emission.contents = emission
        node.geometry?.firstMaterial?.normal.contents = normal
        node.position = position
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.paused {
            guard let touchLocation = touches.first?.location(in: sceneView) else { return }
            let hits = self.sceneView.hitTest(touchLocation, options: nil)
        
            if let tappednode = hits.first?.node {
                //do something with tapped object
                let foundItem = planetObjects.filter { $0.name == (tappednode.name)?.replacingOccurrences(of: "Object", with: "") }
                
//                print("foundItem: \(foundItem)")
                
                if let rotationSpeedAroundTheSun = foundItem.first?.universeRotationSpeed {
                    self.distanceFromTheSunLabel.text = "Rotation: \(rotationSpeedAroundTheSun)"
                }
                
                self.nameLabel.text = foundItem.first?.name

                //add it to parents subview
                self.view.addSubview(planetInfoView)
                self.view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: planetInfoView)
                self.view.addConstraintsWithFormat(format: "V:|-80-[v0(150)]", views: planetInfoView)
                
                planetInfoView.addSubview(nameLabel)
                planetInfoView.addSubview(distanceFromTheSunLabel)
                
                planetInfoView.addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: nameLabel)
                planetInfoView.addConstraintsWithFormat(format: "H:|-6-[v0]-6-|", views: distanceFromTheSunLabel)
                planetInfoView.addConstraintsWithFormat(format: "V:|-6-[v0]-2-[v1]", views: nameLabel, distanceFromTheSunLabel)
            }
        }
    }
}
