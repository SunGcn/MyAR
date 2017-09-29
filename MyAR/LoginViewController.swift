//
//  LoginViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/9/29.
//  Copyright © 2017年 孙港. All rights reserved.
//


//
//  LoginViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/9/28.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        let welcomeLbl = UILabel(frame:CGRect(x:45, y:60, width:mainSize.width - 30, height:50))
        welcomeLbl.text = "欢迎使用"
        welcomeLbl.font = UIFont.systemFont(ofSize: 25)
        welcomeLbl.textColor = UIColor(displayP3Red: 19/255.0, green: 111/255.0, blue: 207/255.0, alpha: 1)
        welcomeLbl.textAlignment = .left
        self.view.addSubview(welcomeLbl)
        
        let authorLbl = UILabel(frame:CGRect(x:mainSize.width/2 - 100, y:mainSize.height-30, width: 200, height:30))
        authorLbl.text = "By Sun.G"
        authorLbl.font = UIFont.italicSystemFont(ofSize: 15)
        authorLbl.textColor = UIColor(displayP3Red: 19/255.0, green: 111/255.0, blue: 207/255.0, alpha: 1)
        authorLbl.textAlignment = .center
        self.view.addSubview(authorLbl)
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x:15, y:100, width:mainSize.width - 30, height:200))
        //vLogin.layer.borderWidth = 0.5
        //vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x:30, y:30, width:vLogin.frame.size.width - 60, height:40))
        txtUser.delegate = self
        txtUser.autocorrectionType = UITextAutocorrectionType.no
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame:CGRect(x:0, y:0, width:44, height:44))
        txtUser.leftViewMode = UITextFieldViewMode.always
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x:11, y:11, width:22, height:22))
        imgUser.image = UIImage(named:"user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x:30, y:90, width:vLogin.frame.size.width - 60, height:40))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame:CGRect(x:0, y:0, width:44, height:44))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x:11, y:11, width:22, height:22))
        imgPwd.image = UIImage(named:"password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        let loginBtn = UIButton(type: UIButtonType.system)
        loginBtn.setTitle("登 录", for: UIControlState())
        loginBtn.layer.cornerRadius = 8
        loginBtn.frame = CGRect(x: 195, y: 150, width: 120, height: 35)
        //sendButton.setImage(UIImage(named:"button"), for: UIControlState.normal)
        loginBtn.backgroundColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        loginBtn.tintColor = UIColor.white
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), for: UIControlEvents.touchUpInside)
        vLogin.addSubview(loginBtn)
        
        let registerBtn = UIButton(type: UIButtonType.system)
        registerBtn.setTitle("注 册", for: UIControlState())
        registerBtn.layer.cornerRadius = 8
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        registerBtn.frame = CGRect(x: 30, y: 150, width: 120, height: 35)
        registerBtn.backgroundColor = UIColor.white
        registerBtn.tintColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        registerBtn.addTarget(self, action: #selector(LoginViewController.register), for: UIControlEvents.touchUpInside)
        vLogin.addSubview(registerBtn)
       
       
    }

    @objc func login(){
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func register(){
        
    }

    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.PASS)
            {
                showType = LoginShowType.USER
                return
            }
            showType = LoginShowType.USER
            
            
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd){
            if (showType == LoginShowType.PASS)
            {
                showType = LoginShowType.PASS
                return
            }
            showType = LoginShowType.PASS
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}






