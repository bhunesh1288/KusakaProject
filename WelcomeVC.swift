   //
//  WelcomeVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 28/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit
//import Alamofire

class WelcomeVC: UIViewController {

    @IBOutlet weak var btn_getstarted: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_getstarted.layer.cornerRadius = btn_getstarted.layer.frame.height/2
        self.navigationController?.isNavigationBarHidden = true

//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    
    
    
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func getstarted_Action(_ sender: Any)
    {
        if let data_IsLogin = UserDefaults.standard.value(forKey: "isLogin") as? Data
        {
            print("data_IsLogin is:-",data_IsLogin)
            let dict_IsLogin = NSKeyedUnarchiver.unarchiveObject(with:data_IsLogin) as! [String:Any]
            print("dict_IsLogin is:-",dict_IsLogin)
            func_CallLoginAPI(username: dict_IsLogin["userName"] as! String, userPWD: dict_IsLogin["userPWD"] as! String)
            
        }
        else
        {
//            let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
//            self.navigationController?.pushViewController(LoginVC!, animated: true)
            
            let dict_IsLogin = [
                "userName":"",
                "userPWD":""
            ]
            
            let data_Dict_IsLogin = NSKeyedArchiver.archivedData(withRootObject: dict_IsLogin)
            UserDefaults.standard.setValue(data_Dict_IsLogin, forKey: "isSkip")
            let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
            self.navigationController?.pushViewController(DashboardVC!, animated: true)
        }
        
//        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
//        self.navigationController?.pushViewController(DashboardVC!, animated: true)
        
    }
    
    func func_CallLoginAPI(username:String, userPWD:String)
    {
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        let setparameters = ["LoginForm[username]":username ,"LoginForm[password]":userPWD,"device_id":deviceID]
        print(setparameters)
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL("site/login", params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        let success=tempDict["success"] as!   Int
                                        //   let message=tempDict["message"] as!   String
                                        
                                        if success==1
                                        {
                                            CommenModel.setObjectWithUserDefault(object: tempDict, keyName: "Details")
                                            UserModel.sharedInstance.updateUserDetails(lobjDict: tempDict)
                                            
                                            let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
                                            self.navigationController?.pushViewController(DashboardVC!, animated: true)
                                
                                        }
                                            
                                        else
                                        {
                                            
                                            // CommenModel.showDefaltAlret(strMessage:message, controller: self)
                                        }
                                        
                                        
        }) { (error) in
            print(error)
            AutoBcmLoadingView.dismiss()
        }
    }

    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
