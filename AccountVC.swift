//
//  AccountVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class AccountVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var img_cart: UIImageView!
    @IBOutlet weak var lbl_countcart: UILabel!
    @IBOutlet weak var tbl_Account: UITableView!
    @IBOutlet weak var view_tab: UIView!
    var tempArr = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        if UserDefaults.standard.object(forKey: "highscore") != nil
        {
            
            self.lbl_countcart.text = UserDefaults.standard.value(forKey: "highscore") as? String
        }
        else
        {
            
        }
        view_tab.layer.shadowColor = UIColor.lightGray.cgColor
        view_tab.layer.shadowOpacity = 5.0
        view_tab.layer.shadowRadius = 5.0
        view_tab.layer.shadowOffset = CGSize (width: 1.5, height: 1.5)
        view_tab.layer.masksToBounds = false
        view_tab.layer.cornerRadius = 5.0

        tbl_Account.tableFooterView = UIView()
        img_cart.layer.cornerRadius = img_cart.layer.frame.height/2
        img_cart.layer.borderWidth = 1
        img_cart.layer.borderColor = (UIColor .init(red: 189.0/255.0, green: 89.0/255.0, blue: 49.0/255.0, alpha: 1)).cgColor
        img_cart.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.tbl_Account.reloadData()
        
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
    @IBAction func menu_Action(_ sender: Any)
    {
        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(DashboardVC!, animated: false)
    }
    @IBAction func cart_Action(_ sender: Any)
    {
//        let CartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC")
//        self.navigationController?.pushViewController(CartVC!, animated: false)
        
        let CartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        CartVC.tempArr = self.tempArr
        
        self.navigationController?.pushViewController(CartVC, animated: false)
    }
    
    @IBAction func orders_Action(_ sender: Any)
    {
//        let OrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC")
//        self.navigationController?.pushViewController(OrdersVC!, animated: false)
        
        let OrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        OrdersVC.tempArr = self.tempArr
        self.navigationController?.pushViewController(OrdersVC, animated: false)
    }
    
    //    MARK:- tableView's methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 558
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return 1
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell_Add = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
//        cell_Add.img_order.layer.cornerRadius = cell_Add.img_order.layer.frame.height/2
//        cell_Add.btn_cancel.layer.cornerRadius = cell_Add.btn_cancel.layer.frame.height/2
//        cell_Add.img_order.clipsToBounds = true
//        cell_Add.btn_cancel.clipsToBounds = true
        
        if (UserDefaults.standard.value(forKey: "isLogin") as? Data) != nil
        {
            cell_Add.lbl_fullname.text = UserModel.sharedInstance.first_Name  + " " + UserModel.sharedInstance.last_Name
            cell_Add.lbl_email.text = UserModel.sharedInstance.Email
            
            cell_Add.btn_logout.addTarget(self, action: #selector(btn_logout(_:)), for: .touchUpInside)
            cell_Add.btn_logout.setTitle("Logout",for: .normal)
        }
        else
        {
            cell_Add.lbl_fullname.text = "Guest User"
            cell_Add.lbl_email.text = ""
            
            cell_Add.btn_logout.addTarget(self, action: #selector(btn_login(_:)), for: .touchUpInside)
            cell_Add.btn_logout.setTitle("Login",for: .normal)
        }
        
        
        
        cell_Add.btn_personaldetails.addTarget(self, action: #selector(btn_PersonalDetails(_:)), for: .touchUpInside)
        cell_Add.btn_changepassword.addTarget(self, action: #selector(btn_ChangePassword(_:)), for: .touchUpInside)
        
        
        cell_Add.btn_about.addTarget(self, action: #selector(btn_about(_:)), for: .touchUpInside)
        cell_Add.btn_instagram.addTarget(self, action: #selector(btn_instagram(_:)), for: .touchUpInside)
        cell_Add.btn_contact.addTarget(self, action: #selector(btn_contact(_:)), for: .touchUpInside)
        cell_Add.btn_shareapp.addTarget(self, action: #selector(btn_shareapp(_:)), for: .touchUpInside)
        
        
        
        
        return cell_Add
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
    }
    @IBAction func btn_PersonalDetails(_ sender: UIButton)
    {
        if (UserDefaults.standard.value(forKey: "isLogin") as? Data) != nil
        {
            let PersonalDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalDetailsVC")
            self.present(PersonalDetailsVC!, animated: true, completion: nil)
        }
        else
        {
            let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.navigationController?.pushViewController(LoginVC!, animated: true)
        }
        
        
    }
    @IBAction func btn_ChangePassword(_ sender: UIButton)
    {
       
        
        if (UserDefaults.standard.value(forKey: "isLogin") as? Data) != nil
        {
            let ChangePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC")
            self.present(ChangePasswordVC!, animated: true, completion: nil)
        }
        else
        {
            let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.navigationController?.pushViewController(LoginVC!, animated: true)
        }
    }
    @IBAction func btn_logout(_ sender: UIButton)
    {
    
        let refreshAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:
            {
                (action: UIAlertAction!) in
                //            self.navigationController?.popToRootViewController(animated: true)
                
                self.logoutFun()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:
            {
                (action: UIAlertAction!) in
                refreshAlert .dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)

    }
    @IBAction func btn_login(_ sender: UIButton)
    {
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(LoginVC!, animated: true)
    }
    func logoutFun()
    {
        UserDefaults.standard.removeObject(forKey: "isLogin")
        UserDefaults.standard.removeObject(forKey: "isSignup")
        let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.navigationController?.pushViewController(LoginVC!, animated: false)
        
    }
    @IBAction func btn_about(_ sender: UIButton)
    {
        let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC")
        self.present(aboutVC!, animated: true, completion: nil)
    }
    @IBAction func btn_instagram(_ sender: UIButton)
    {
        let InstagramVC = self.storyboard?.instantiateViewController(withIdentifier: "InstagramVC")
        self.present(InstagramVC!, animated: true, completion: nil)
    }
    @IBAction func btn_contact(_ sender: UIButton)
    {
        let ContactVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC")
        self.present(ContactVC!, animated: true, completion: nil)
    }
    @IBAction func btn_shareapp(_ sender: UIButton)
    {
        if let myWebsite = NSURL(string: "https://www.kusakarestaurant.com") {
            let objectsToShare = [myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
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
