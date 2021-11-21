//
//  ViewController.swift
//  ruler-ios
//
//  Created by Tigran Arsenyan on 11/11/21.
//

import UIKit
import ARKit

class RulerViewController: UIViewController {
    //MARK: Properties
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var resultButton: UIButton!
    @IBOutlet private weak var resultButtonContainer: UIView!
    @IBOutlet private weak var sessionLabel: UILabel!
    @IBOutlet private weak var modeButton: UIButton!
    @IBOutlet private weak var flashButton: UIButton!
    
    private var nodes: [RulerNodes] = []
    private var meauseremntType: MeasurementType = .meters
    private var measurementMode: MeasurementMode = .line
    private var pickerNode: PickerNode?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self

        resetTracking()
        initUi()
        setNodes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }
    
    // MARK: Private methods.
    private func initUi() {
        // making blur bg for button
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
                    UIBlurEffect.Style.regular))
        blur.frame = resultButtonContainer.bounds
        resultButtonContainer.insertSubview(blur, at: 0)
        
        blur.layer.cornerRadius = 20
        sessionLabel.layer.cornerRadius = 20
        resultButtonContainer.layer.cornerRadius = 20
        
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.titleLabel?.font = resultButton.titleLabel?.font.withSize(25)
        
        flashButton.setImage(UIImage(named: "flashDisabled"), for: .normal)
        flashButton.setImage(UIImage(named: "flashActive"), for: .selected)
        
        modeButton.setImage(UIImage(named: "shapeDisabled"), for: .normal)
        modeButton.setImage(UIImage(named: "shapeActive"), for: .selected)
    }
    
    private func setNodes() {
        removeAllNodes()
        
        pickerNode = PickerNode()
        sceneView.scene.rootNode.addChildNode(pickerNode!)
    }
    
    private func setResultButtonText(_ endVector: SCNVector3? = nil) {
        guard let lastNode = nodes.last else { return }
        
        resultButton.setTitle("\(String(format: "%.01f", lastNode.getDistance(meauseremntType))) \(meauseremntType.getShortName())", for: .normal)
    }
    
    /// - Returns: returnes the world position of the center of the screen
    private func getCenterWorldPosition() -> SCNVector3? {
        let screenCenter : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        let planeTestResults = sceneView.hitTest(screenCenter, types: [.existingPlaneUsingExtent])
        
        if let result = planeTestResults.first {
            return SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        }
        
        return nil
    }
    
    private func getCameraRotation() -> SCNVector3? {
        guard let pointOfView = sceneView.pointOfView else { return nil }
        
        return pointOfView.eulerAngles
    }
    
    /// turning on/off the torch
    private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    // not able to turn on the torch
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            // can't lock the devices configuration
            print(error)
        }
    }
    
    /// adding a node in the center if the scereen.
    private func addPoint() {
        guard let worldPosition = getCenterWorldPosition() else { return }
        
        let sphere = SCNSphere(radius: 0.008)
        sphere.firstMaterial?.diffuse.contents = UIColor.rulerYellow
        
        let node = SCNNode(geometry: sphere)
        node.position = worldPosition
        sceneView.scene.rootNode.addChildNode(node)
        
        if nodes.last?.isComplete() == true || nodes.isEmpty {
            // making new ruler node
            let lineNode = SCNNode()
            let textNode = DrawnTextNode()
            let rulerNode = RulerNodes(startNode: node, lineNode: lineNode, textNode: textNode)
            
            nodes.append(rulerNode)
             
            sceneView.scene.rootNode.addChildNode(lineNode)
            sceneView.scene.rootNode.addChildNode(textNode)
        } else {
            // the ruler node ends
            nodes.last?.setEndNode(node, type: meauseremntType, textRotation: getCameraRotation() ?? SCNVector3(0, 0, 0))
            setResultButtonText()
            
            if measurementMode == .ruler {
                let lineNode = SCNNode()
                let textNode = DrawnTextNode()
                let rulerNode = RulerNodes(startNode: node, lineNode: lineNode, textNode: textNode)
                
                sceneView.scene.rootNode.addChildNode(lineNode)
                sceneView.scene.rootNode.addChildNode(textNode)
                
                nodes.append(rulerNode)
            }
        }
    }
    
    private func removeAllNodes() {
        nodes.forEach({ $0.removeNodes() })
        nodes.removeAll()
        resultButton.setTitle("", for: .normal)
    }
    
    /// depeneds on ARSession tracking state, the method shows or hides a label which indicates about the state of the ar session if there is something wrong
    /// - Parameters:
    ///   - frame: ARFrame
    ///   - trackingState: the session's state.
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String

        switch trackingState {
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""

        }
        
        sessionLabel.text = message
        sessionLabel.isHidden = message.isEmpty
        pickerNode?.isHidden = !message.isEmpty
    }
    
    /// every time changing the position of the line which is created between start node and the Picker Node.
    private func updateCurrentLinePosition() {
        if let node = nodes.last, !node.isComplete(), let centerWorldVector = getCenterWorldPosition(), let cameraRotation = getCameraRotation() {
            node.buildLineWithTextNode(start: node.getStart().position, end: centerWorldVector, type: meauseremntType, textRotation: cameraRotation)
            node.setEndVector(centerWorldVector)
            setResultButtonText()
        }
    }
    
    /// when the ARKit is not able to find a plane in the center of the screen, this method disables the Picker Node, otherwise it enables the Picker Node.
    private func enableOrDisablePickerNode () {
        let screenCenter : CGPoint = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        
        if let hitTest = sceneView.hitTest(screenCenter, types: .existingPlaneUsingExtent).first,
            let planeAnchor = hitTest.anchor as? ARPlaneAnchor,
            let anchoredNode = sceneView.node(for: planeAnchor),
            let position = getCenterWorldPosition() {
            // ARKit could find a plane
            pickerNode?.position = position
            pickerNode?.rotation = anchoredNode.rotation
            pickerNode?.enable()
        } else if let featurePoint = sceneView.hitTest(screenCenter, types: .featurePoint).first {
            // ARKit couldn't find a plane
            pickerNode?.position = SCNVector3Make(featurePoint.worldTransform.columns.3.x, featurePoint.worldTransform.columns.3.y, featurePoint.worldTransform.columns.3.z)
            pickerNode?.disable()
        }
    }
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    
    // MARK: IBActions
    @IBAction func toggleModeAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        measurementMode = sender.isSelected ? .ruler : .line
        removeAllNodes()
    }
    
    @IBAction func reloadAction(_ sender: UIButton) {
        removeAllNodes()
    }
    
    @IBAction func rulerAction(_ sender: UIButton) {
        addPoint()
    }
    
    @IBAction func flashLightAction(_ sender: UIButton) {
        toggleTorch()
        sender.isSelected.toggle()
    }
    
    @IBAction func changeMeasurementType(_ sender: UIButton) {
        meauseremntType.next()
        setResultButtonText()
    }
}

extension RulerViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // when there is a plane.
            self.updateCurrentLinePosition()
            self.enableOrDisablePickerNode()
        }
    }
}

extension SCNVector3 {
    static func +(lhv:SCNVector3, rhv:SCNVector3) -> SCNVector3 {
         return SCNVector3(lhv.x + rhv.x, lhv.y + rhv.y, lhv.z + rhv.z)
    }
}
