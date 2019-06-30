//
//  PersonalDetailsVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class PersonalDetailsVC: UIViewController {

     private var toast: JYToast!
    @IBOutlet weak var img_firstname: UIImageView!
    @IBOutlet weak var img_lastname: UIImageView!
    @IBOutlet weak var img_email: UIImageView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()

        img_firstname.layer.cornerRadius = img_firstname.layer.frame.height/2
        img_lastname.layer.cornerRadius = img_lastname.layer.frame.height/2
        img_email.layer.cornerRadius = img_email.layer.frame.height/2
        
        img_firstname.layer.borderWidth = 1
        img_firstname.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
        
        img_lastname.layer.borderWidth = 1
        img_lastname.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
        
        img_email.layer.borderWidth = 1
        img_email.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
        
       

        // Do any additional setup after loading the view.
    }
    private func initUi() {
        toast = JYToast()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.txtFiedFirstname.text = UserModel.sharedInstance.first_Name
        self.txtFiedLastname.text = UserModel.sharedInstance.last_Name
        self.txtFiedEmail.text = UserModel.sharedInstance.Email
    }
    
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    
    
    
    
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    func editProfileApiCallMethods() {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        let setparameters = ["User[first_name]":txtFiedFirstname.text! ,"User[last_name]":txtFiedLastname.text!,"User[email]":txtFiedEmail.text!]
        print(setparameters)
        let str_FullUrl = "user/edit-profile"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
        print("str_FullUrl is:-",str_FullUrl)
        
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL(str_FullUrl, params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        
                                        CommenModel.setObjectWithUserDefault(object: tempDict, keyName: "Details")
                                        UserModel.sharedInstance.updateUserDetails(lobjDict: tempDict)
                                        
                                        if UserModel.sharedInstance.status == true {
                                            if UserModel.sharedInstance.isDualAuth == true
                                            {
                                                let message = UserModel.sharedInstance.message
                                                
                                                print(message)
                                                
                                                 self.toast.isShow(message)
                                                self.dismiss(animated: true, completion: nil)
                                                
                                                //iToast.makeText(message).show()
                                                //CommenModel.showDefaltAlret(strMessage:UserModel.sharedInstance.message, controller: self)
                                                
                                            }
                                            else
                                            {
                                                let message = UserModel.sharedInstance.message
                                                
                                                self.toast.isShow(message)
                                                // CommenModel.showDefaltAlret(strMessage:UserModel.sharedInstance.message, controller: self)
                                                //     CommenModel.setObjectWithUserDefault(object: UserModel.sharedInstance.key, keyName: "Key")
                                                //     CommenModel.setObjectWithUserDefault(object: "loged", keyName: "signIn")
                                                //    NotificationCenter.default.post(name: Notification.Name("addDashboardIdentifier"), object: nil)
                                            }
                                        }else {
                                            
                                            CommenModel.showDefaltAlret(strMessage:UserModel.sharedInstance.message, controller: self)
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
        self.editProfileApiCallMethods()
       // self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
