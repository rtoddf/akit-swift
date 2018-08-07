import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        registerGestureRecognizers()
//        self.sceneView.autoenablesDefaultLighting = true
        
    }
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func tapped(recognizer :UIGestureRecognizer) {
        print("tap")
        
        guard let currentFrame = self.sceneView.session.currentFrame else {
            return
        }
        
//        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
//        let request = URLRequest(url: URL(string: "http://www.rtodd.net/")!)
//
//        webView.loadRequest(request)
//
//        let tvPlane = SCNPlane(width: 1.0, height: 0.75)
//        tvPlane.firstMaterial?.diffuse.contents = webView
//        tvPlane.firstMaterial?.isDoubleSided = true
//
//        let tvPlaneNode = SCNNode(geometry: tvPlane)
//
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -1.5
//
//        tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
//        tvPlaneNode.eulerAngles = SCNVector3(0,0,0)
//
//        self.sceneView.scene.rootNode.addChildNode(tvPlaneNode)
        
        let videoNode = SKVideoNode(fileNamed: "big_buck_bunny.mp4")
        videoNode.play()

        let skScene = SKScene(size: CGSize(width: 1600, height: 900))
        skScene.addChild(videoNode)

        videoNode.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
        videoNode.size = skScene.size

        let tvPlane = SCNPlane(width: 1.0, height: 0.5265)
        tvPlane.firstMaterial?.diffuse.contents = skScene
        tvPlane.firstMaterial?.isDoubleSided = true

        let tvPlaneNode = SCNNode(geometry: tvPlane)

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5

        tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        tvPlaneNode.eulerAngles = SCNVector3(Double.pi,0,0)

        self.sceneView.scene.rootNode.addChildNode(tvPlaneNode)
    }
    
}
