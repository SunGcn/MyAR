//
//  MapViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/9/29.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    var textView:UITextView!// 输入框
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let mainSize = UIScreen.main.bounds.size
        
        let cameraBtn = UIButton(type: UIButtonType.system)
        cameraBtn.frame = CGRect(x: mainSize.width - 50, y: mainSize.height - 50, width: 40, height: 40)
        cameraBtn.setImage(UIImage(named:"camera"), for: UIControlState.normal)
        cameraBtn.addTarget(self, action: #selector(MapViewController.camera), for: UIControlEvents.touchUpInside)
        self.view.addSubview(cameraBtn)
        
        // 创建输入框
        
        textView = UITextView(frame:CGRect(x: 10, y:mainSize.height - 40 - 10, width: mainSize.width - 70,height: 40))
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.black
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true
        textView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        textView.contentInset = UIEdgeInsetsMake(1, 1, 0, 0)
        textView.showsHorizontalScrollIndicator = true
        self.view.addSubview(textView)
        
        registNotification()
    }

    @objc func camera(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.textView.frame = CGRect(x: 10, y: self.textView.frame.maxY - deltaY, width: self.textView.frame.width ,height: self.textView.frame.height)
            //self.sendButton.frame = CGRect(x: SCREENWIDTH - self.textView.frame.width - 10 - 10, y: 340, width: 60,height: h)
           // self.sendButton.frame = CGRect(x: w, y: 345, width: 60, height: 36)
        }
        // 判断是否需要动画
        if duration > 0 {
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        //currentY = textView.frame.origin.y
    }
    
    // 将要收起
    @objc func keyboardWillHid(_ notification:Notification){
        
        let userInfo  = notification.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            //self.view.transform = CGAffineTransform.identity
            
            //self.textView.frame = CGRect(x: 10, y:self.view.frame.height - self.textViewHeight - 10, width: self.view.frame.width - 20 - 60 - 10,height: self.textViewHeight)
            //self.backgroundView.frame = CGRect(x: 10,y: self.view.frame.height - 40,width: self.textViewW+2,height: 32)
            let w = self.textView.frame.width
            //self.sendButton.frame = CGRect(x: 20 + w, y:self.view.frame.height - self.textViewHeight - 10 , width: 60, height: 36)
            self.textView.textColor = UIColor.lightGray
            
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        //currentY = textView.frame.origin.y
    }
    
    // 将要改变
    @objc func keyboardWillChange(_ notification:Notification){
        let contentSize = self.textView.contentSize
        //print(contentSize.height)
        if contentSize.height > 140{
            //print(contentSize.height)
            return;
        }
        var selfframe = self.view.frame
        // selfHight的计算我也不太清楚 等大神解答..
        var selfHeight = (self.textView.superview?.frame.origin.y)! * 2 + contentSize.height
        ///if selfHeight <= selfDefultHight {
        // /   selfHeight = selfDefultHight
        ///}
        let selfOriginY = selfframe.origin.y - (selfHeight - selfframe.size.height)
        selfframe.origin.y  = selfOriginY;
        selfframe.size.height = selfHeight;
        self.view.frame = selfframe;
        
        
        //self.textView.contentInset = UIEdgeInsetsMake(-1, 1, 0, 0)
        
        //self.textView.frame = CGRect(x: 10, y:currentY - contentSize.height + 36, width: self.view.frame.width - 20 - 60 - 10,height: contentSize.height )
        
        
        self.textView.scrollRangeToVisible(NSRange(location: -1,length: 0))
        
        //print(self.textView.textContainer.lineFragmentPadding)
        //print(self.textView.textContainerInset.top)
        //print(self.textView.textContainerInset.bottom)
        //        //self.backgroundView.frame = CGRect(x: 10, y: self.view.frame.height - 40, width: textViewW+2, height: selfHeight-18);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
