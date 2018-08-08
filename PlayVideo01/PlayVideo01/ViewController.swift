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
        
        let labelMargin:Int = 40
        let labelWidth:Int = 750
        let labelHeight:Int = 750
        
        let videoNode = SKVideoNode(fileNamed: "big_buck_bunny.mp4")
        videoNode.play()

        let skScene = SKScene(size: CGSize(width: 1600, height: 900))
        skScene.addChild(videoNode)

        videoNode.size = CGSize(width: (skScene.size.width/2) - (CGFloat(labelMargin) * 2), height: ((skScene.size.width/2) - (CGFloat(labelMargin) * 2)) * 9/16)
        videoNode.position = CGPoint(x: skScene.size.width/2 + videoNode.size.width/2 + CGFloat(labelMargin), y: (skScene.size.height - videoNode.size.height/2) - CGFloat(labelMargin))
        skScene.backgroundColor = .clear
        
        
        let labelPosition:CGPoint = CGPoint(x: CGFloat(labelWidth/2) + CGFloat(labelMargin), y: CGFloat(skScene.size.height) - CGFloat(labelMargin))
        
        let newTitleLabel = SKMultilineLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed lacus ornare, ornare sem et, tristique lectus. Vestibulum in fringilla enim. Duis fringilla lectus id placerat porttitor.", labelWidth: Int((skScene.size.width/2) - (CGFloat(labelMargin) * 2)), pos: labelPosition)
        
        newTitleLabel.alignment = .left
        newTitleLabel.leading = 60
        newTitleLabel.fontColor = .white
        newTitleLabel.fontSize = 60
        skScene.addChild(newTitleLabel)
        
        // printing stuff out
        // print("x: \((skScene.size.height/2) - (CGFloat(labelMargin) * 2) - CGFloat(labelMargin))")
        // print("y: \((skScene.size.height - videoNode.size.height/2) - CGFloat(labelMargin))")

        let videoPlane = SCNPlane(width: 1.0, height: 0.5265)
        videoPlane.firstMaterial?.diffuse.contents = skScene
        videoPlane.firstMaterial?.isDoubleSided = true

        let videoPlaneNode = SCNNode(geometry: videoPlane)

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5

        videoPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        videoPlaneNode.eulerAngles = SCNVector3(Double.pi,0,0)

        self.sceneView.scene.rootNode.addChildNode(videoPlaneNode)
    }
    
}

//        UIColor(white: 0.5, alpha: 0.5)
