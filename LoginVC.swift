//
//  LoginVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 24/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var img_Email: UIImageView!
    @IBOutlet weak var img_Password: UIImageView!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_signup: UIButton!
    @IBOutlet weak var btn_Guest: UIButton!
    @IBOutlet weak var txtFiedEmail: DesignableUITextField!
        {
        didSet {
            self.txtFiedEmail.delegate = self as? UITextFieldDelegate
         
        }
    }
    @IBOutlet weak var txtFieldPassword: DesignableUITextField!
        {
        didSet {
            self.txtFieldPassword.delegate = self as? UITextFieldDelegate
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = true
        img_Email.layer.cornerRadius = img_Email.layer.frame.height/2
        img_Password.layer.cornerRadius = img_Password.layer.frame.height/2
        
        btn_login.layer.cornerRadius = btn_login.layer.frame.height/2
        btn_signup.layer.cornerRadius = btn_signup.layer.frame.height/2
        btn_signup.layer.borderWidth = 1
        btn_signup.layer.borderColor = (UIColor .white).cgColor
        
//        btn_Guest.layer.borderWidth = 1
//        btn_Guest.layer.borderColor = (UIColor .white).cgColor
        
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }

    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    func validateMethod ()  -> Bool{
        
        guard  !(self.txtFiedEmail.text )!.isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter email ID", controller: self)
            return false
        }
        guard ((txtFiedEmail.text?.isValidEmail())!)else {
            
            CommenModel.showDefaltAlret(strMessage: "Please enter valid email ID", controller: self)
            return false
            
        }
        guard  !(self.txtFieldPassword.text )!.isEmpty  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter password", controller: self)
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
    func loginApiCallMethods() {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        let setparameters = ["LoginForm[username]":txtFiedEmail.text! ,"LoginForm[password]":txtFieldPassword.text!,"device_id":deviceID]
        print(setparameters)
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL("site/login", params: setparameters as [String : AnyObject],headers: nil,
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
                                                "userName":self.txtFiedEmail!.text!,
                                                "userPWD":self.txtFieldPassword!.text!
                                            ]
                                            
                                            let data_Dict_IsLogin = NSKeyedArchiver.archivedData(withRootObject: dict_IsLogin)
                                            UserDefaults.standard.setValue(data_Dict_IsLogin, forKey: "isLogin")
                                            
                                            let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
                                            self.navigationController?.pushViewController(DashboardVC!, animated: true)
                                         //   CommenModel.showDefaltAlret(strMessage:message, controller: self)
                                        }
                                        
                                        else
                                        {
                                            
                                            CommenModel.showDefaltAlret(strMessage:message, controller: self)
                                        }
              
        }) { (error) in
            print(error)
            AutoBcmLoadingView.dismiss()
        }
    }
    
    
    
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func login_Action(_ sender: Any)
    {
        guard validateMethod() else {
            return
        }
        txtFiedEmail.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
        self.loginApiCallMethods()
        
//        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
//        self.navigationController?.pushViewController(DashboardVC!, animated: true)
    }
    @IBAction func forgot_Action(_ sender: Any)
    {
        let ForgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotVC")
        self.present(ForgotVC!, animated: true, completion: nil)
        


    }
    
    @IBAction func signup_Action(_ sender: Any)
    {
        let SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
        self.navigationController?.pushViewController(SignUpVC!, animated: true)
    }
    @IBAction func guest_Action(_ sender: Any)
    {
        let dict_IsLogin = [
            "userName":"",
            "userPWD":""
        ]
        
        let data_Dict_IsLogin = NSKeyedArchiver.archivedData(withRootObject: dict_IsLogin)
        UserDefaults.standard.setValue(data_Dict_IsLogin, forKey: "isSkip")
        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(DashboardVC!, animated: true)
    }
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
