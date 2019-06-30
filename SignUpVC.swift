//
//  SignUpVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 27/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    @IBOutlet weak var img_Firstname: UIImageView!
    @IBOutlet weak var img_Lastname: UIImageView!
    @IBOutlet weak var img_Email: UIImageView!
    @IBOutlet weak var img_Password: UIImageView!
    @IBOutlet weak var img_cnfPassword: UIImageView!
    @IBOutlet weak var btn_Guest: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_signup: UIButton!
    @IBOutlet weak var txtFiedFirstname: DesignableUITextField!
        {
        didSet {
            self.txtFiedFirstname.delegate = self as? UITextFieldDelegate
            //   self.txtFiedEmail.inputView = UIView()
        }
    }
    @IBOutlet weak var txtFiedLastname: DesignableUITextField!
        {
        didSet {
            self.txtFiedLastname.delegate = self as? UITextFieldDelegate
            //   self.txtFiedEmail.inputView = UIView()
        }
    }
    @IBOutlet weak var txtFiedEmail: DesignableUITextField!
        {
        didSet {
            self.txtFiedEmail.delegate = self as? UITextFieldDelegate
         //   self.txtFiedEmail.inputView = UIView()
        }
    }
    @IBOutlet weak var txtFieldPassword: DesignableUITextField!
        {
        didSet {
            self.txtFieldPassword.delegate = self as? UITextFieldDelegate
        }
    }
    @IBOutlet weak var txtFieldCnfPassword: DesignableUITextField!
        {
        didSet {
            self.txtFieldCnfPassword.delegate = self as? UITextFieldDelegate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = true
        
        img_Firstname.layer.cornerRadius = img_Firstname.layer.frame.height/2
        img_Lastname.layer.cornerRadius = img_Lastname.layer.frame.height/2
        img_Email.layer.cornerRadius = img_Email.layer.frame.height/2
        img_Password.layer.cornerRadius = img_Password.layer.frame.height/2
        img_cnfPassword.layer.cornerRadius = img_Password.layer.frame.height/2
        
        btn_login.layer.cornerRadius = btn_login.layer.frame.height/2
        btn_signup.layer.cornerRadius = btn_signup.layer.frame.height/2
        btn_login.layer.borderWidth = 1
        btn_login.layer.borderColor = (UIColor .white).cgColor

         self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    func validateMethod ()  -> Bool{
        guard  !(self.txtFiedFirstname.text )!.isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter first name", controller: self)
            return false
        }
        guard  !(self.txtFiedLastname.text )!.isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter last name", controller: self)
            return false
        }
        
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
        
        guard (self.txtFieldPassword.text?.characters.count)! >= 6 else {
            
            CommenModel.showDefaltAlret(strMessage:"You must be provide at least 6 to 30 character for Password", controller: self)
            return false
            
        }
        guard  !(self.txtFieldCnfPassword.text )!.isEmpty  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter confirm password", controller: self)
            return false
        }
        guard (self.txtFieldPassword.text == self.txtFieldCnfPassword.text) else {
            
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
    func signupApiCallMethods() {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        let setparameters = ["User[first_name]":txtFiedFirstname.text!,"User[last_name]":txtFiedLastname.text!,"User[email]":txtFiedEmail.text! ,"User[newpassword]":txtFieldPassword.text!,"User[confirmpassword]":txtFieldCnfPassword.text!,"User[device_id]":deviceID]
        print(setparameters)
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL("site/signup", params: setparameters as [String : AnyObject],headers: nil,
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
                                            CommenModel.showDefaltAlret(strMessage:message, controller: self)
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
    @IBAction func privacy_Action(_ sender: Any)
    {
        let PrivacyVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyVC")
        self.present(PrivacyVC!, animated: true, completion: nil)
    }
    @IBAction func terms_Action(_ sender: Any)
    {
        let TermsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC")
        self.present(TermsVC!, animated: true, completion: nil)
    }
    
    @IBAction func login_Action(_ sender: Any)
    {
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(LoginVC!, animated: false)
    }
    
    @IBAction func signup_Action(_ sender: Any)
    {
        guard validateMethod() else {
            return
        }
        txtFiedFirstname.resignFirstResponder()
        txtFiedLastname.resignFirstResponder()
        txtFiedEmail.resignFirstResponder()
        txtFieldPassword.resignFirstResponder()
        txtFieldCnfPassword.resignFirstResponder()
        
        self.signupApiCallMethods()
        
//        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
//        self.navigationController?.pushViewController(DashboardVC!, animated: true)
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
extension String {
    func isValidmobile() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[0-9]", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))  != nil
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
        
        
    }
}
extension String {
    
    func validate() -> Bool {
        let string = " "
        return (string.rangeOfCharacter(from: CharacterSet.whitespaces) != nil)
    }
}
