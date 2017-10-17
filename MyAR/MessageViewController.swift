//
//  MessageViewController.swift
//  MyAR
//
//  Created by 孙港 on 2017/10/13.
//  Copyright © 2017年 孙港. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        
        let nameLbl = UILabel(frame:CGRect(x:40, y:40, width:mainSize.width - 30, height:50))
        nameLbl.text = "From: " + authorOfMessage
        nameLbl.font = UIFont.systemFont(ofSize: 20)
        nameLbl.textColor = UIColor.black
        nameLbl.textAlignment = .left
        self.view.addSubview(nameLbl)
        
        let idLbl = UILabel(frame:CGRect(x:40, y:80, width:mainSize.width - 30, height:50))
        idLbl.text = "ID: " + idOfMessage
        idLbl.font = UIFont.systemFont(ofSize: 20)
        idLbl.textColor = UIColor.black
        idLbl.textAlignment = .left
        self.view.addSubview(idLbl)
        
        let contentLbl = UILabel(frame:CGRect(x:40, y:120, width:mainSize.width - 30, height:50))
        contentLbl.text = "Content: " + contentOfMessage
        contentLbl.font = UIFont.systemFont(ofSize: 20)
        contentLbl.textColor = UIColor.black
        contentLbl.textAlignment = .left
        self.view.addSubview(contentLbl)
        
        let quitBtn = UIButton(type: UIButtonType.system)
        quitBtn.frame = CGRect(x:mainSize.width - 210, y:mainSize.height-30, width: 200, height:30)
        let str1 = NSMutableAttributedString(string: "取消")
        let range1 = NSRange(location: 0, length: str1.length)
        let number = NSNumber(value:NSUnderlineStyle.styleSingle.rawValue)
        str1.addAttribute(NSAttributedStringKey.underlineStyle, value: number, range: range1)
        str1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(displayP3Red: 19/255.0, green: 111/255.0, blue: 207/255.0, alpha: 1), range: range1)
        quitBtn.setAttributedTitle(str1, for: .normal)
        quitBtn.contentHorizontalAlignment = .right
        quitBtn.addTarget(self, action: #selector(MessageViewController.quit), for: UIControlEvents.touchUpInside)
        self.view.addSubview(quitBtn)
        
    }

    @objc func quit(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
