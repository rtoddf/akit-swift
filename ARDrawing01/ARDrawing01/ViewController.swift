import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        
        self.sceneView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // gives us the point of view
        guard let pointOfView = sceneView.pointOfView else { return }
        
        // point of view contains the current location and orientation of the camera view
        // they are coded into the point of view as a transform matrix
        let transform = pointOfView.transform
        // from the transform, extract the current orientation
        // the x in the third column, row 1
        // the y in the third column, row 2
        // the z in the third column, row 3
        // the orientation is reversed, so a negative is needed
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        
        // now we need the location of the camera
        // the x in the fourth column, row 1
        // the y in the fourth column, row 2
        // the z in the fourth column, row 3
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        // now we can get the current position
        let currentPositionOfCamera = orientation + location

        // the orientation is reversed, so a negative is needed
        print(orientation.x, orientation.y, orientation.z)
        
        // you left off at #28
    }

}

func +(left:SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}







