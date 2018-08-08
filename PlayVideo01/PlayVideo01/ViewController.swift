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
//        videoNode.size = skScene.size
        skScene.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        
        let labelPosition:CGPoint = CGPoint(x: CGFloat(labelWidth/2) + CGFloat(labelMargin), y: CGFloat(skScene.size.height) - CGFloat(labelMargin))
        
        let newTitleLabel = SKMultilineLabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed lacus ornare, ornare sem et, tristique lectus. Vestibulum in fringilla enim. Duis fringilla lectus id placerat porttitor.", labelWidth: labelWidth, pos: labelPosition)
        
//        print("x: \((skScene.size.height/2) - (CGFloat(labelMargin) * 2) - CGFloat(labelMargin))")
        print("y: \((skScene.size.height - videoNode.size.height/2) - CGFloat(labelMargin))")
        
//        newTitleLabel.labelHeight = labelHeight
        newTitleLabel.alignment = .left
        newTitleLabel.leading = 60
//        newTitleLabel.fontColor = .red
        newTitleLabel.fontSize = 60
        skScene.addChild(newTitleLabel)
        
//        let titleLabel = SKLabelNode(fontNamed:"HelveticaNeue-Bold")
//        titleLabel.horizontalAlignmentMode = .right
//        titleLabel.fontSize = 36
//        titleLabel.text = String("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sed lacus ornare, ornare sem et, tristique lectus")
//        titleLabel.fontColor = .white
//
//        titleLabel.position = CGPoint(x: skScene.size.width/2, y: skScene.size.height/2)
//        skScene.addChild(titleLabel)

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

