//
//  ViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/9/29.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        let mainSize = UIScreen.main.bounds.size
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        let loginBtn = UIButton(type: UIButtonType.system)
        //loginBtn.setTitle("登 录", for: UIControlState())
        //loginBtn.layer.cornerRadius = 8
        loginBtn.frame = CGRect(x: mainSize.width - 50, y: mainSize.height - 50, width: 40, height: 40)
        loginBtn.setImage(UIImage(named:"login"), for: UIControlState.normal)
        //loginBtn.backgroundColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        //loginBtn.tintColor = UIColor.white
        loginBtn.addTarget(self, action: #selector(ViewController.login), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginBtn)
        
        let mapBtn = UIButton(type: UIButtonType.system)
        //loginBtn.setTitle("登 录", for: UIControlState())
        //loginBtn.layer.cornerRadius = 8
        mapBtn.frame = CGRect(x: 10, y: mainSize.height - 50, width: 40, height: 40)
        mapBtn.setImage(UIImage(named:"map"), for: UIControlState.normal)
        //loginBtn.backgroundColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        //loginBtn.tintColor = UIColor.white
        mapBtn.addTarget(self, action: #selector(ViewController.map), for: UIControlEvents.touchUpInside)
        self.view.addSubview(mapBtn)
    }
    
    @objc func login(){
        //let viewController = ViewController()
        //self.present(viewController, animated: true, completion: nil)
        let loginView = LoginViewController()
        //从下弹出一个界面作为登陆界面，completion作为闭包，可以写一些弹出loginView时的一些操作
        self.present(loginView, animated: true, completion: nil)
    }
    
    @objc func map(){
        //let viewController = ViewController()
        //self.present(viewController, animated: true, completion: nil)
        let loginView = MapViewController()
        //从下弹出一个界面作为登陆界面，completion作为闭包，可以写一些弹出loginView时的一些操作
        self.present(loginView, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
