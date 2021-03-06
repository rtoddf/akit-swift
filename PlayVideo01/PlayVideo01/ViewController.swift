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
        
        // skScene
        let skScene = SKScene(size: CGSize(width: 1600, height: 900))
        skScene.backgroundColor = .clear

        let labelMargin:CGFloat = 40
        let labelWidth = (skScene.size.width/2) - (labelMargin * 2)

        // textLabel
        let labelPosition:CGPoint = CGPoint(x: CGFloat(labelWidth/2) + labelMargin, y: CGFloat(skScene.size.height) - labelMargin)
        let newTitleLabel = SKMultilineLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed lacus ornare, ornare sem et, tristique lectus. Vestibulum in fringilla enim. Duis fringilla lectus id placerat porttitor.", labelWidth: Int(labelWidth), pos: labelPosition)
        
        newTitleLabel.alignment = .left
        newTitleLabel.fontColor = .white
        newTitleLabel.leading = 60
        newTitleLabel.fontSize = 60
        skScene.addChild(newTitleLabel)
        
        // printing stuff out
        // print("x: \((skScene.size.height/2) - (CGFloat(labelMargin) * 2) - CGFloat(labelMargin))")
        // print("y: \((skScene.size.height - videoNode.size.height/2) - CGFloat(labelMargin))")

        // video
        let videoNode = SKVideoNode(fileNamed: "big_buck_bunny.mp4")
        videoNode.play()
        videoNode.size = CGSize(width: (skScene.size.width/2) - (labelMargin * 2), height: ((skScene.size.width/2) - (labelMargin * 2)) * 9/16)
        videoNode.position = CGPoint(x: skScene.size.width/2 + videoNode.size.width/2 + labelMargin, y: (skScene.size.height - videoNode.size.height/2) - labelMargin)
        skScene.addChild(videoNode)
        
        let videoPlane = SCNPlane(width: 1.0, height: 0.5265)
        videoPlane.firstMaterial?.diffuse.contents = skScene
        videoPlane.firstMaterial?.isDoubleSided = true

        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        let videoPlaneNode = SCNNode(geometry: videoPlane)
        videoPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        videoPlaneNode.eulerAngles = SCNVector3(Double.pi,0,0)
        self.sceneView.scene.rootNode.addChildNode(videoPlaneNode)
        
        // browser
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        let request = URLRequest(url: URL(string: "http://www.rtodd.net/")!)
        webView.loadRequest(request)

        let browserPlane = SCNPlane(width: 0.45, height: 0.45 * 9/16)

        browserPlane.firstMaterial?.diffuse.contents = webView
        browserPlane.firstMaterial?.isDoubleSided = true

        var browserTranslation = matrix_identity_float4x4
        browserTranslation.columns.3.x = 0.18
        browserTranslation.columns.3.y = 0.25
        browserTranslation.columns.3.z = -1.5

        let browserPlaneNode = SCNNode(geometry: browserPlane)
        browserPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, browserTranslation)
        browserPlaneNode.eulerAngles = SCNVector3(0,0,0)

        self.sceneView.scene.rootNode.addChildNode(browserPlaneNode)
    }
    
}

//        UIColor(white: 0.5, alpha: 0.5)
