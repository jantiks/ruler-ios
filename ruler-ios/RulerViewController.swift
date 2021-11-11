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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func reloadAction(_ sender: UIButton) {
    }
    
    @IBAction func rulerAction(_ sender: UIButton) {
    }
    
    @IBAction func flashLightAction(_ sender: UIButton) {
    }
}

