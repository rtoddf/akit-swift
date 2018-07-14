import UIKit
import ARKit

struct planetaryObject {
    var name:String
    var geometry:SCNGeometry
    var diffuseImage:UIImage
    var specularImage:UIImage?
    var emissionImage:UIImage?
    var normalImage:UIImage?
    var position:SCNVector3
    var universeRotationSpeed:Double
    var rotationSpeed:Double
    var axisTilt:Float
    
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


////node.geometry = geometry
//createPlanetaryBody(geometry:SCNGeometry, diffuse:UIImage, specular:UIImage?, emission:UIImage?, normal:UIImage?, position:SCNVector3) -> SCNNode {
//    let node = SCNNode()
//    node.geometry = geometry
//    node.geometry?.firstMaterial?.diffuse.contents = diffuse
//    node.geometry?.firstMaterial?.specular.contents = specular
//    node.geometry?.firstMaterial?.emission.contents = emission
//    node.geometry?.firstMaterial?.normal.contents = normal
//    node.position = position
