
//
//  ViewController.swift
//  project_ios11
//
//  Created by 孙港 on 2017/9/20.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,UITextViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mainMapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var navigationBar:UINavigationBar?
    
    var textView:UITextView!// 输入框
    var textViewY:CGFloat!
    var textViewWidth:CGFloat!
    var textViewHeight:CGFloat = 40
    
    var cameraBtn:UIButton!
    var cameraBtnY:CGFloat!
    var cameraBtnWidth:CGFloat = 40
    var cameraBtnHeight:CGFloat = 40
 
    var currentY:CGFloat!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let mainSize = UIScreen.main.bounds.size
        // Do any additional setup after loading the view, typically from a nib.
        //使用代码创建
        //navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 100))
        //self.view.addSubview(navigationBar!)
        
        self.mainMapView = MKMapView(frame:self.view.frame)
        self.view.addSubview(self.mainMapView)
        self.mainMapView.mapType = MKMapType.mutedStandard
        self.mainMapView.delegate = self
        self.mainMapView.showsUserLocation = true
        self.mainMapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        //let latDelta = 0.05
        //let longDelta = 0.05
        //let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用当前位置
        //let center:CLLocation = locationManager.location!.coordinate
        //使用自定义位置
        //let center:CLLocation = CLLocation(latitude: 32.029171, longitude: 118.788231)
        //let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,span: currentLocationSpan)
        
        //设置显示区域
        //self.mainMapView.setRegion(currentRegion, animated: true)
        
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = CLLocation(latitude: 32.029171,longitude: 118.788231).coordinate
        //设置点击大头针之后显示的标题
        objectAnnotation.title = "南京夫子庙"
        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle = "南京市秦淮区秦淮河北岸中华路"
        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位精确度（最高）一般有电源接入，比较耗电
        //kCLLocationAccuracyNearestTenMeters;//精确到10米
        locationManager.distanceFilter = 5 //设备移动后获得定位的最小距离（适合用来采集运动的定位）
        locationManager.requestWhenInUseAuthorization()//弹出用户授权对话框，使用程序期间授权（ios8后)
        //requestAlwaysAuthorization;//始终授权
        locationManager.startUpdatingLocation()
        
        cameraBtnY = mainSize.height - 50
        cameraBtn = UIButton(type: UIButtonType.system)
        cameraBtn.frame = CGRect(x: mainSize.width - 50, y: cameraBtnY, width: cameraBtnWidth, height: cameraBtnHeight)
        cameraBtn.setImage(UIImage(named:"camera"), for: UIControlState.normal)
        cameraBtn.addTarget(self, action: #selector(MapViewController.camera), for: UIControlEvents.touchUpInside)
        self.view.addSubview(cameraBtn)
        
        textViewWidth = mainSize.width - 70
        textViewY = mainSize.height - 40 - 10
        textView = UITextView(frame:CGRect(x: 10, y: textViewY, width: textViewWidth,height: textViewHeight))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.text = "我有话说"
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true
        textView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        textView.contentInset = UIEdgeInsetsMake(1, 1, 0, 0)
        textView.showsHorizontalScrollIndicator = true
        //textView.returnKeyType = .send
        textView.delegate = self
        self.view.addSubview(textView)
        
        registNotification()
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self,action:#selector(MapViewController.handleTap(sender:))))

    }
    
    
    @objc func handleTap(sender:UITapGestureRecognizer){
        if sender.state == .ended{
            self.textView.resignFirstResponder()
        }
    }
    
    func textViewShouldReturn(textView:UITextView) -> Bool
    {
        textView.resignFirstResponder()
        return true
    }
    
    @objc func camera(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        //print(currentLocation.coordinate.latitude)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位出错拉！！\(error)")
    }
    
    //自定义大头针样式
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                //let messageView = MKAnnotationView()
                //messageView.image = UIImage(named: "self")
                //messageView.canShowCallout = true
                //return messageView
                return nil
            }
            
            let messageView = MKAnnotationView()
            messageView.image = UIImage(named: "pin")
            messageView.canShowCallout = true
            return messageView
            
    }
    
    // 注册通知
    func registNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHid(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    // 将要出现
    @objc func keyboardWillShow(_ notification:Notification){
        
        // 通知传参
        let userInfo  = notification.userInfo
        // 取出键盘bounds
        let  keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 时间
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        // 动画模式
        let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        // 偏移量
        let deltaY = keyBoardBounds.size.height
        // 动画
        let animations:(() -> Void) = {
            //self.view.transform = CGAffineTransform(translationX: 0,y: -deltaY)
            self.textView.text = ""
            self.textView.textColor = UIColor.black
            //let w = self.sendButton.frame.origin.x
            self.textView.frame = CGRect(x: 10, y: self.textViewY - deltaY, width: self.textView.frame.width ,height: self.textView.frame.height)
            self.cameraBtn.frame = CGRect(x: self.cameraBtn.frame.origin.x,y: self.cameraBtnY - deltaY,width: self.cameraBtn.frame.width,height: self.cameraBtn.frame.height)
            //self.sendButton.frame = CGRect(x: SCREENWIDTH - self.textView.frame.width - 10 - 10, y: 340, width: 60,height: h)
            // self.sendButton.frame = CGRect(x: w, y: 345, width: 60, height: 36)
        }
        // 判断是否需要动画
        if duration > 0 {
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        currentY = self.textView.frame.origin.y
    }
    
    // 将要收起
    @objc func keyboardWillHid(_ notification:Notification){
        
        let userInfo  = notification.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            //self.view.transform = CGAffineTransform.identity
            
            self.textView.frame = CGRect(x: 10, y: self.textViewY, width: self.textViewWidth,height: self.textViewHeight)
            self.cameraBtn.frame = CGRect(x: self.cameraBtn.frame.origin.x,y: self.cameraBtnY,width: self.cameraBtnWidth,height: self.cameraBtnHeight)
            //self.backgroundView.frame = CGRect(x: 10,y: self.view.frame.height - 40,width: self.textViewW+2,height: 32)
            //let w = self.textView.frame.width
            ////self.sendButton.frame = CGRect(x: 20 + w, y:self.view.frame.height - self.textViewHeight - 10 , width: 60, height: 36)
            self.textView.text = "我有话说"
            self.textView.textColor = UIColor.lightGray
            
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    // 将要改变
    @objc func keyboardWillChange(_ notification:Notification){
        let contentSize = self.textView.contentSize
        //var textViewMaxHeight:CGFloat!
        //textViewMaxHeight = contentSize.height
        if contentSize.height > 140{
            //textViewMaxHeight = contentSize.height - 15
            return;
        }
        
        //self.textView.contentInset = UIEdgeInsetsMake(-1, 1, 0, 0)
        self.textView.frame = CGRect(x: 10, y: currentY - contentSize.height + 36, width: self.textViewWidth,height: contentSize.height)
        self.textView.scrollRangeToVisible(NSRange(location: -1,length: 0))
        
   }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}

