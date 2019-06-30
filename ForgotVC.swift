//
//  ForgotVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 28/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class ForgotVC: UIViewController {
    
      @IBOutlet weak var img_Email: UIImageView!
      @IBOutlet weak var btn_resetpassword: UIButton!
    @IBOutlet weak var txtFiedEmail: DesignableUITextField!
        {
        didSet {
            self.txtFiedEmail.delegate = self as? UITextFieldDelegate
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = true
         self.navigationController?.isNavigationBarHidden = true
        img_Email.layer.cornerRadius = img_Email.layer.frame.height/2
        btn_resetpassword.layer.cornerRadius = btn_resetpassword.layer.frame.height/2
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
        guard CommenModel.isConnetctedToInternet() else{
            CommenModel.showDefaltAlret(strMessage:"Please check internet connection.", controller: self)
            return false
        }
        return  true
    }
    
    
    
    
    
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    func forgotPasswordWebServiceApi() {
        
        let setparameters = ["recovery_email":txtFiedEmail.text!]
        print(setparameters)
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL("site/forgot-password", params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        let lStatus = tempDict.value(forKey: "success") as! Bool
                                        let message = tempDict.value(forKey: "message") as! String
                                        if lStatus == true {
                                    //        CommenModel.setObjectWithUserDefault(object: "loged", keyName: "signIn")
                                      //      NotificationCenter.default.post(name: Notification.Name("addDashboardIdentifier"), object: nil)
                                            CommenModel.showDefaltAlret(strMessage:message, controller: self)
                                           // self.dismiss(animated: true, completion: nil)
                                            
                                            
                                        }else{
                                            // Somethign wrong
                                        }
                                        
                                        
                                        CommenModel.showDefaltAlret(strMessage:message, controller: self)
                                        
        }) { (error) in
            print(error)
            CommenModel.showDefaltAlret(strMessage:error.localizedDescription, controller: self)
            
            AutoBcmLoadingView.dismiss()
        }
    }
    
    
    
    
    
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func resetpass_Action(_ sender: Any)
    {
        guard validateMethod() else {
            return
        }
         self.forgotPasswordWebServiceApi()
       //  self.dismiss(animated: true, completion: nil)
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionFade
//        transition.subtype = kCATransitionFromBottom
//        navigationController?.view.layer.add(transition, forKey:kCATransition)
//        navigationController?.popViewController(animated: false)
        
      //  self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back_Action(_ sender: Any)
    {

        self.dismiss(animated: true, completion: nil)
        // self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
