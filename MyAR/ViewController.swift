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
import CoreData
import CoreLocation

extension UIImage {
    func drawTextInImage(content: String)->UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x:0,y:0,width:self.size.width,height:self.size.height))
        let attr = [ NSAttributedStringKey.foregroundColor : UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1), NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]
        let text = NSString(string: content)
        let size =  text.size(withAttributes: attr)
        text.draw(in: CGRect(x:30,y:12, width:size.width, height:size.height), withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if start{
            let view = MapViewController()
            self.present(view, animated: true, completion: nil)
            start = false
        }
        
        let mainSize = UIScreen.main.bounds.size

        let loginBtn = UIButton(type: UIButtonType.system)
        loginBtn.frame = CGRect(x: mainSize.width - 50, y: mainSize.height - 50, width: 40, height: 40)
        loginBtn.setImage(UIImage(named:"login"), for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(ViewController.login), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginBtn)
        
        let mapBtn = UIButton(type: UIButtonType.system)
        mapBtn.frame = CGRect(x: 10, y: mainSize.height - 50, width: 40, height: 40)
        mapBtn.setImage(UIImage(named:"map"), for: UIControlState.normal)
        mapBtn.addTarget(self, action: #selector(ViewController.map), for: UIControlEvents.touchUpInside)
        self.view.addSubview(mapBtn)
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            
            //遍历查询的结果
            for info in fetchedObjects{
                //let currentLocation = CLLocation(latitude: selfLatitude_Double, longitude: selfLongitude_Double)
                //let messageLocation = CLLocation(latitude: info.latitude, longitude: info.longitude)
                
                //if getDistance(selfLocation: currentLocation, messageLocation: messageLocation) < MAXDISTANCE{
                //生成带文字图片
                let letter:String = info.content!
                let sise = CGSize(width: 400, height: 50)
                let rect = CGRect(origin: CGPoint.zero, size: sise)
                UIGraphicsBeginImageContext(sise)
                let ctx = UIGraphicsGetCurrentContext()
                ctx?.setFillColor(UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5).cgColor)
                ctx?.fill(rect)
                let attr = [ NSAttributedStringKey.foregroundColor : UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1), NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]
                (letter as NSString).draw(at: CGPoint(x: 50, y: 10), withAttributes: attr)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let material = SCNMaterial()
                material.diffuse.contents = image
                let white = SCNMaterial()
                white.diffuse.contents = UIImage(named: "white")
                let planeGeometry = SCNPlane(width: 8,height: 1)
                planeGeometry.cornerRadius = 0.2
                let planeNode = SCNNode(geometry: planeGeometry)
                planeNode.geometry?.materials  = [material, white]
                planeNode.opacity = 1
                //let theta:Double = selfDirection_Double * Double.pi / 180.0
                //let x0:Double = getHorizonalDistance(selfLocation: currentLocation, messageLocation: messageLocation)
                //let y0:Double = getVerticalDistance(selfLocation: currentLocation, messageLocation: messageLocation)
                //let x:Float = Float(x0 * cos(theta) - y0 * sin(theta))
                //let y:Float = Float(y0 * cos(theta) + x0 * sin(theta))
                //let z:Float = Float(-getDistance(selfLocation: currentLocation, messageLocation: messageLocation))
                let a:Float = Float(arc4random() % 4)
                planeNode.position = SCNVector3Make(a, a, -20)
                planeNode.name = info.timestamp!
                //self.scene.rootNode.addChildNode(planeNode)
                //}
                
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
        
        
        
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let scnView = self.view as! SCNView
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            let timestamp = result.node.name!
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
            let predicate = NSPredicate(format: "timestamp= \(timestamp) ", "")
            fetchRequest.predicate = predicate
            do {
                let fetchedObjects = try context.fetch(fetchRequest)
                
                //遍历查询的结果
                for info in fetchedObjects{
                    authorOfMessage = info.name!
                    idOfMessage = info.timestamp!
                    contentOfMessage = info.content!
                }
            }
            catch {
                fatalError("不能保存：\(error)")
            }
            let view = MessageViewController()
            self.present(view, animated: true, completion: nil)
        }
    }
    
    
    @objc func login(){
        let loginView = LoginViewController()
        self.present(loginView, animated: true, completion: nil)
    }
    
    @objc func map(){
        let loginView = MapViewController()
        self.present(loginView, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        let scene = SCNScene()
       
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Message>(entityName:"Message")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            //遍历查询的结果
            for info in fetchedObjects{
                let currentLocation = CLLocation(latitude: selfLatitude_Double, longitude: selfLongitude_Double)
                let messageLocation = CLLocation(latitude: info.latitude, longitude: info.longitude)
                
                if getDistance(selfLocation: currentLocation, messageLocation: messageLocation)
                    < MAXDISTANCE{
                    //生成带文字图片
                    let letter:String = info.content!
                    let sise = CGSize(width: 400, height: 50)
                    let rect = CGRect(origin: CGPoint.zero, size: sise)
                    UIGraphicsBeginImageContext(sise)
                    let ctx = UIGraphicsGetCurrentContext()
                    ctx?.setFillColor(UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0,           alpha: 15).cgColor)
                    ctx?.fill(rect)
                    let attr = [ NSAttributedStringKey.foregroundColor : UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1), NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]
                    (letter as NSString).draw(at: CGPoint(x: 50, y: 10), withAttributes: attr)
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    let material = SCNMaterial()
                    material.diffuse.contents = image
                    let white = SCNMaterial()
                    white.diffuse.contents = UIImage(named: "white")
                    let planeGeometry = SCNBox(width: 8, height: 1, length: 0.2, chamferRadius: 0.1)//SCNPlane(width: 8,height: 1)
                    //planeGeometry.cornerRadius = 0.2
                    let planeNode = SCNNode(geometry: planeGeometry)
                    planeNode.geometry?.materials  = [material, white]
                    planeNode.opacity = 0.75
                    
                    let theta:Double = selfDirection_Double * Double.pi / 180.0
                   
                    let x0:Double = getHorizonalDistance(selfLocation: currentLocation, messageLocation: messageLocation)
                    let y0:Double = getVerticalDistance(selfLocation: currentLocation, messageLocation: messageLocation)
                    
                    let x:Float = Float(x0 * cos(theta) - y0 * sin(theta))
                    let y:Float = Float(y0 * cos(theta) + x0 * sin(theta))
                    let z:Float = Float(getDistance(selfLocation: currentLocation, messageLocation: messageLocation))
                    
                    var alpha:Double = 0.0
                    if x>=0{
                        alpha = acos(Double(y/z))
                    }
                    else{
                        alpha = Double.pi + acos(Double(-y/z))
                    }

                    planeNode.position = SCNVector3Make(x, z / Float(MAXDISTANCE), -y)
                    planeNode.rotation = SCNVector4Make( 0, 1, 0,-Float(alpha))
                    
                    
                    planeNode.name = info.timestamp!
                    //scene.rootNode.addChildNode(planeNode)
                    
                    // 想要绘制的 3D 立方体
                    let boxGeometry = SCNBox(width: 8, height: 1, length: 0, chamferRadius: 0)
                    let boxNode = SCNNode(geometry: boxGeometry)
                    
                    var h:Float = 0
                    if z > Float(MAXDISTANCE) / 2{
                        h = 10
                    }
                    else if z > Float(MAXDISTANCE) / 4{
                        h = 5
                    }
                    else if z > Float(MAXDISTANCE) / 8{
                        h = 2
                    }
                    else{
                        h = 0
                    }
                    
                    var s = Float(sqrt(Double(h)))
                    if s == 0{
                        s = 1
                    }
                    
                    boxNode.position = SCNVector3Make(x, h, -y)
                    boxNode.rotation = SCNVector4Make( 0, 1, 0,-Float(alpha))
                    boxNode.scale = SCNVector3Make(s,s,s)
                    let messageframe = SCNMaterial()
                    messageframe.diffuse.contents = UIImage(named: "messageframe")?.drawTextInImage(content: info.content!)
                    //let white = UIImage(named: "white")
                    boxNode.geometry?.materials  = [messageframe]
                    boxNode.opacity = 1
                    boxNode.name = info.timestamp!
                    scene.rootNode.addChildNode(boxNode)
                   
                    
                }
            }
        }
        catch {
            
        }
        
        /*// 想要绘制的 3D 立方体
        let boxGeometry = SCNBox(width: 8, height: 1, length: 0, chamferRadius: 0)
        // 将几何体包装为 node 以便添加到 scene
        let boxNode = SCNNode(geometry: boxGeometry)
        boxNode.position = SCNVector3Make(0, 0, -20)
        let rotation = Double.pi / 4
        boxNode.rotation = SCNVector4Make( 0, 1, 0,Float(rotation))
        boxNode.scale = SCNVector3Make(1,1,1)
        let messageframe = SCNMaterial()
        messageframe.diffuse.contents = UIImage(named: "messageframe")?.drawTextInImage(content: "Hello world!")
        //let white = UIImage(named: "white")
        boxNode.geometry?.materials  = [messageframe]
        boxNode.opacity = 1
        scene.rootNode.addChildNode(boxNode)*/
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene = scene
        
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
