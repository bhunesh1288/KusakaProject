//
//  ChangePasswordVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    private var toast: JYToast!
    @IBOutlet weak var img_oldpassword: UIImageView!
    @IBOutlet weak var img_newpassword: UIImageView!
    @IBOutlet weak var img_cnfpassword: UIImageView!
    @IBOutlet weak var txtFiedOldPassword: DesignableUITextField!
        {
        didSet {
            self.txtFiedOldPassword.delegate = self as? UITextFieldDelegate
            //   self.txtFiedEmail.inputView = UIView()
        }
    }
    @IBOutlet weak var txtFiedNewPassword: DesignableUITextField!
        {
        didSet {
            self.txtFiedNewPassword.delegate = self as? UITextFieldDelegate
            //   self.txtFiedEmail.inputView = UIView()
        }
    }
    @IBOutlet weak var txtFiedCnfPassword: DesignableUITextField!
        {
        didSet {
            self.txtFiedCnfPassword.delegate = self as? UITextFieldDelegate
            //   self.txtFiedEmail.inputView = UIView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         initUi()
//        UINavigationBar.appearance().clipsToBounds = true
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor.black
        
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.black
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
        
        // self.navigationController?.isNavigationBarHidden = true
        img_oldpassword.layer.cornerRadius = img_oldpassword.layer.frame.height/2
        img_newpassword.layer.cornerRadius = img_newpassword.layer.frame.height/2
        img_cnfpassword.layer.cornerRadius = img_cnfpassword.layer.frame.height/2
        
        img_oldpassword.layer.borderWidth = 1
        img_oldpassword.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
        
        img_newpassword.layer.borderWidth = 1
        img_newpassword.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
        
        img_cnfpassword.layer.borderWidth = 1
        img_cnfpassword.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor

        // Do any additional setup after loading the view.
    }
    private func initUi() {
        toast = JYToast()
    }
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    func validateMethod ()  -> Bool{
        
        guard  !(self.txtFiedOldPassword.text )!.isEmpty  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter old password", controller: self)
            return false
        }
        guard  !(self.txtFiedNewPassword.text )!.isEmpty  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter new password", controller: self)
            return false
        }
        guard  !(self.txtFiedCnfPassword.text )!.isEmpty  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter confirm password", controller: self)
            return false
        }
        
        guard (self.txtFiedNewPassword.text == self.txtFiedCnfPassword.text) else {
            
            CommenModel.showDefaltAlret(strMessage:"Password not match", controller: self)
            return false
            
        }
        guard CommenModel.isConnetctedToInternet() else{
            CommenModel.showDefaltAlret(strMessage:"Please check internet connection.", controller: self)
            return false
        }
        return  true
    }
    
    
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    func changePasswordApiCallMethods() {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        let setparameters = ["ChangePassword[oldpassword]":txtFiedOldPassword.text! ,"ChangePassword[newpassword]":txtFiedNewPassword.text!,"ChangePassword[repeatnewpassword]":txtFiedCnfPassword.text!]
        print(setparameters)
        let str_FullUrl = "user/change-password"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
        print("str_FullUrl is:-",str_FullUrl)
        
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL(str_FullUrl, params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        
                                        let success=tempDict["success"] as!   Int
                                        let message=tempDict["message"] as!   String
                                        
                                        if success==1
                                        {
                                            CommenModel.setObjectWithUserDefault(object: tempDict, keyName: "Details")
                                            UserModel.sharedInstance.updateUserDetails(lobjDict: tempDict)
                                            
                                            let dict_IsLogin = [
                                                "userName":UserModel.sharedInstance.Email,
                                                "userPWD":self.txtFiedCnfPassword!.text!
                                            ]

                                            let data_Dict_IsLogin = NSKeyedArchiver.archivedData(withRootObject: dict_IsLogin)
                                            UserDefaults.standard.setValue(data_Dict_IsLogin, forKey: "isLogin")
                                            
                                           
                                            self.toast.isShow(message)
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                            
                                        else
                                        {
                                             self.toast.isShow(message)
                                            
                                        }
                                        
                                        
        }) { (error) in
            print(error)
            AutoBcmLoadingView.dismiss()
        }
    }
    
  
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func back_Action(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save_Action(_ sender: Any)
    {
        guard validateMethod() else {
            return
        }
        self.changePasswordApiCallMethods()
       
    }
   
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
