import UIKit
import ARKit
import SpriteKit

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
                    }
                }
            }
            
            self.sunNode.runAction(self.sunForever, forKey: "sunAction")
            
            if ((planetInfoView.superview) != nil) {
                planetInfoView.removeFromSuperview()
                nameLabel.removeFromSuperview()
                radiusLabel.removeFromSuperview()
                distanceLabel.removeFromSuperview()
                funFactLabel.removeFromSuperview()
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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        return view
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    let radiusLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    let distanceLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    let funFactLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        printFonts()
        
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
        let sun = planetaryObject(name: "Sun", geometry: SCNSphere(radius: sunRadius), diffuseImage: #imageLiteral(resourceName: "Sundiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: position, universeRotationSpeed: 0.rotationAroundTheSun, rotationSpeed: 648.rotationOnAxis, axisTilt: 7.5, radius: "432169 mi", distance: "0 mi")
        self.sunNode = createPlanetaryBody(name: sun.name, geometry: sun.geometry, diffuse: sun.diffuseImage, specular: sun.specularImage, emission: sun.emissionImage, normal: sun.normalImage, position: sun.position)
        self.sceneView.scene.rootNode.addChildNode(self.sunNode)

        let sunTilt = sun.axisTilt * .pi/180
        sunNode.eulerAngles = SCNVector3(0, 0, sunTilt)
        
        self.sunAction = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: sun.rotationSpeed)
        self.sunForever = SCNAction.repeatForever(self.sunAction)
        sunNode.runAction(self.sunForever, forKey: "sunAction")
    }
    
    func setPlanetaryObject() -> [planetaryObject] {
        let mercury = planetaryObject(name: "Mercury", geometry: SCNSphere(radius: CGFloat(1516.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MercuryDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(35.distanceToSun), 0, 0), universeRotationSpeed: 88.rotationAroundTheSun, rotationSpeed: 2112.rotationOnAxis, axisTilt: 2.11, radius: "1516 mi", distance: "35.98 million mi")
        let venus = planetaryObject(name: "Venus", geometry: SCNSphere(radius:CGFloat(3760.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "VenusDiffuse"), specularImage: nil, emissionImage: #imageLiteral(resourceName: "VenusSpecular"), normalImage: nil, position: SCNVector3(CGFloat(67.distanceToSun), 0, 0), universeRotationSpeed: 225.rotationAroundTheSun, rotationSpeed: 5832.rotationOnAxis, axisTilt: 177.3, radius: "3760 mi", distance: "67.24 million mi")
        let earth = planetaryObject(name: "Earth", geometry: SCNSphere(radius: CGFloat(3959.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "EarthDiffuse"), specularImage: #imageLiteral(resourceName: "EarthSpecular"), emissionImage: #imageLiteral(resourceName: "EarthEmission"), normalImage: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(CGFloat(92.distanceToSun), 0, 0), universeRotationSpeed: 365.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis, axisTilt: 23.5, radius: "3959 mi", distance: "92.96 million mi")
        
        let mars = planetaryObject(name: "Mars", geometry: SCNSphere(radius: CGFloat(2106.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "MarsDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(141.distanceToSun), 0, 0), universeRotationSpeed: 687.rotationAroundTheSun, rotationSpeed: 25.rotationOnAxis, axisTilt: 25, radius: "2106 mi", distance: "141.6 million mi")
        let jupiter = planetaryObject(name: "Jupiter", geometry: SCNSphere(radius: CGFloat(43441.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "JupiterDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(483.distanceToSun), 0, 0), universeRotationSpeed: 4380.rotationAroundTheSun, rotationSpeed: 10.rotationOnAxis, axisTilt: 3, radius: "43441 mi", distance: "483.8 million mi")
        
        // don't forget the rings
        let saturn = planetaryObject(name: "Saturn", geometry: SCNSphere(radius: CGFloat(36184.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "SaturnDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(890.distanceToSun), 0, 0), universeRotationSpeed: 11000.rotationAroundTheSun, rotationSpeed: 24.rotationOnAxis, axisTilt: 26.7, radius: "36184 mi", distance: "890.7 million miles")
        
        let uranus = planetaryObject(name: "Uranus", geometry: SCNSphere(radius: CGFloat(15759.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "UranusDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(1784.distanceToSun), 0, 0), universeRotationSpeed: 31000.rotationAroundTheSun, rotationSpeed: 17.rotationOnAxis, axisTilt: 23.5, radius: "15759 mi", distance: "1784 million miles")
        let neptune = planetaryObject(name: "Neptune", geometry: SCNSphere(radius: CGFloat(15299.getPlanetRadius)), diffuseImage: #imageLiteral(resourceName: "NeptuneDiffuse"), specularImage: nil, emissionImage: nil, normalImage: nil, position: SCNVector3(CGFloat(2800.distanceToSun), 0, 0), universeRotationSpeed: 60225.rotationAroundTheSun, rotationSpeed: 16.rotationOnAxis, axisTilt: 28.32, radius: "15299 mi", distance: "2.8 billion miles")
        
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

                // why does this work??
                // https://stackoverflow.com/questions/49600303/how-to-add-label-to-scnnode
                let sk = SKScene(size: CGSize(width: 3000, height: 2000))
                sk.backgroundColor = UIColor.clear
                
                let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 3000, height: 2000), cornerRadius: 10)
                rectangle.fillColor = UIColor.black
                rectangle.strokeColor = UIColor.white
                rectangle.lineWidth = 5
                rectangle.alpha = 0.75
                
                let lbl = SKLabelNode(text: foundItem.first?.name)
                lbl.fontSize = 320
                lbl.numberOfLines = 0
                lbl.fontColor = UIColor.white
                lbl.fontName = "Helvetica-Bold"
                lbl.position = CGPoint(x:1500,y:1000)
                lbl.preferredMaxLayoutWidth = 2900
                lbl.horizontalAlignmentMode = .center
                lbl.verticalAlignmentMode = .center
                lbl.zRotation = .pi
                
                sk.addChild(rectangle)
                sk.addChild(lbl)
                
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = sk
                
                let plane = SCNPlane(width: 1, height: 1)
                let node = SCNNode(geometry: plane)
                
                node.geometry?.materials = [material]
//                node.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(1), Float(1), 1)
                node.geometry?.firstMaterial?.diffuse.wrapS = .repeat
                node.geometry?.firstMaterial?.diffuse.wrapS = .repeat
                
                node.eulerAngles = SCNVector3(0,CGFloat(180.degreesToRadians),0)
                
                node.position = SCNVector3(0,0,-2)
                self.sceneView.scene.rootNode.addChildNode(node)
                
//                let skScene = SKScene(size: CGSize(width: 2, height: 2))
//                skScene.backgroundColor = UIColor.black.withAlphaComponent(1)
//
//                let labelNode = SKLabelNode(text: "Hello World")
//                labelNode.text = "bob"
//                labelNode.fontSize = 300
//                labelNode.fontName = "GillSans-Bold"
//                labelNode.color = UIColor.clear
//                labelNode.fontColor = UIColor.red
//                labelNode.position = CGPoint(x:100, y:100)
//
//                skScene.addChild(labelNode)
//
//                let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 200), cornerRadius: 10)
//                rectangle.fillColor = #colorLiteral(red: 0.807843148708344, green: 0.0274509806185961, blue: 0.333333343267441, alpha: 1.0)
//                rectangle.strokeColor = #colorLiteral(red: 0.439215689897537, green: 0.0117647061124444, blue: 0.192156866192818, alpha: 1.0)
//                rectangle.lineWidth = 5
//                rectangle.alpha = 0.4
//
//                skScene.addChild(rectangle)
//
//
//
//                let plane = SCNPlane(width: 1, height: 1)
//
//                let material = SCNMaterial()
//                material.isDoubleSided = true
//                material.diffuse.contents = rectangle
//
////                plane.materials = [material]
//                plane.firstMaterial?.diffuse.contents = UIColor.green
//
//                let node = SCNNode(geometry: plane)
//
//
//                node.position = SCNVector3(0,0,-2)
//
//
//                self.sceneView.scene.rootNode.addChildNode(node)
                
//                let foundItem = planetObjects.filter { $0.name == (tappednode.name)?.replacingOccurrences(of: "Object", with: "") }
//                self.nameLabel.text = foundItem.first?.name
//
//                let funFactString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In consequat felis quis libero interdum, a vulputate erat ornare. Cras convallis gravida nibh, quis feugiat eros pellentesque eget."
//                let attributedText = NSMutableAttributedString(string: funFactString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor(hexString: "#fff") as Any])
//                self.funFactLabel.attributedText = attributedText
//
//                if let radius = foundItem.first?.radius,
//                    let distance = foundItem.first?.distance {
//                    self.radiusLabel.text = "Radius: \(radius)"
//                    self.distanceLabel.text = "Distance from the sun: \(distance)"
//                }
//
//                //add it to parents subview
//                self.view.addSubview(planetInfoView)
//                self.view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: planetInfoView)
//                self.view.addConstraintsWithFormat(format: "V:|-50-[v0(200)]", views: planetInfoView)
//
//                planetInfoView.addSubview(nameLabel)
//                planetInfoView.addSubview(radiusLabel)
//                planetInfoView.addSubview(distanceLabel)
//                planetInfoView.addSubview(funFactLabel)
//
//                planetInfoView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: nameLabel)
//                planetInfoView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: radiusLabel)
//                planetInfoView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: distanceLabel)
//                planetInfoView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: funFactLabel)
//
//                planetInfoView.addConstraintsWithFormat(format: "V:|-12-[v0]-4-[v1]-4-[v2]-4-[v3]", views: nameLabel, radiusLabel, distanceLabel, funFactLabel)
            }
        }
    }
}
