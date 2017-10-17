//
//  RegisterViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/9/30.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    //用户密码输入框
    var txtName:UITextField!
    var txtId:UITextField!
    var txtPwd:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        let welcomeLbl = UILabel(frame:CGRect(x:45, y:60, width:mainSize.width - 30, height:50))
        welcomeLbl.text = "欢迎注册"
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
        let vLogin =  UIView(frame:CGRect(x:15, y:100, width:mainSize.width - 30, height:300))
        //vLogin.layer.borderWidth = 0.5
        //vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //用户名输入框
        txtName = UITextField(frame:CGRect(x:30, y:30, width:vLogin.frame.size.width - 60, height:40))
        txtName.delegate = self
        txtName.autocorrectionType = UITextAutocorrectionType.no
        txtName.layer.cornerRadius = 5
        txtName.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        txtName.layer.borderWidth = 0.5
        txtName.leftView = UIView(frame:CGRect(x:0, y:0, width:44, height:44))
        txtName.leftViewMode = UITextFieldViewMode.always
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x:11, y:11, width:22, height:22))
        imgUser.image = UIImage(named:"user")
        txtName.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtName)
        
        //ID输入框
        txtId = UITextField(frame:CGRect(x:30, y:90, width:vLogin.frame.size.width - 60, height:40))
        txtId.delegate = self
        txtId.layer.cornerRadius = 5
        txtId.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        txtId.layer.borderWidth = 0.5
        txtId.leftView = UIView(frame:CGRect(x:0, y:0, width:44, height:44))
        txtId.leftViewMode = UITextFieldViewMode.always
        //ID输入框左侧图标
        let imgName =  UIImageView(frame:CGRect(x:11, y:11, width:22, height:22))
        imgName.image = UIImage(named:"id")
        txtId.leftView!.addSubview(imgName)
        vLogin.addSubview(txtId)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x:30, y:150, width:vLogin.frame.size.width - 60, height:40))
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
        
        
        let registerBtn = UIButton(type: UIButtonType.system)
        registerBtn.setTitle("注 册", for: UIControlState())
        registerBtn.layer.cornerRadius = 8
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1).cgColor
        registerBtn.frame = CGRect(x: 30, y: 210, width: vLogin.frame.size.width - 60, height: 35)
        registerBtn.backgroundColor = UIColor(displayP3Red: 59/255.0, green: 151/255.0, blue: 247/255.0, alpha: 1)
        registerBtn.tintColor = UIColor.white
        registerBtn.addTarget(self, action: #selector(RegisterViewController.register), for: UIControlEvents.touchUpInside)
        vLogin.addSubview(registerBtn)
        
        let quitBtn = UIButton(type: UIButtonType.system)
        quitBtn.frame = CGRect(x:mainSize.width - 210, y:mainSize.height-30, width: 200, height:30)
        let str1 = NSMutableAttributedString(string: "取消")
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value:NSUnderlineStyle.styleSingle.rawValue)
        str1.addAttribute(NSAttributedStringKey.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(displayP3Red: 19/255.0, green: 111/255.0, blue: 207/255.0, alpha: 1), range: range1)
        quitBtn.setAttributedTitle(str1, for: .normal)
        quitBtn.contentHorizontalAlignment = .right
        quitBtn.addTarget(self, action: #selector(RegisterViewController.quit), for: UIControlEvents.touchUpInside)
        self.view.addSubview(quitBtn)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target:self,action:#selector(LoginViewController.handleTap(sender:))))
    }
    
    // 点击屏幕空白处收起键盘
    @objc func handleTap(sender:UITapGestureRecognizer){
        if sender.state == .ended{
            self.txtName.resignFirstResponder()
            self.txtPwd.resignFirstResponder()
            self.txtId.resignFirstResponder()
        }
    }
    
    @objc func register(){
        saveUser(name: txtName.text!, id: txtId.text!, pwd: txtPwd.text!)
        
        self.txtName.resignFirstResponder()
        self.txtId.resignFirstResponder()
        self.txtPwd.resignFirstResponder()
        let alertController = UIAlertController(title: "注册成功!",message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc func quit(){
        
        self.dismiss(animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
