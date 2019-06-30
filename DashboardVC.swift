//
//  DashboardVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit
//import DropDown
import M13Checkbox

class DashboardVC: UIViewController, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource  {
    
    @IBOutlet weak var img_cart: UIImageView!
    @IBOutlet weak var lbl_countcart: UILabel!
    @IBOutlet weak var lbl_comingssoon: UILabel!
    @IBOutlet weak var view_tab: UIView!
    @IBOutlet weak var view_black: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tbl_Cart: UITableView!
     @IBOutlet weak var tbl_chawchaw: UITableView!
    @IBOutlet weak var view_Menutab: UIView!
    @IBOutlet weak var btn_restaurantmenu: UIButton!
    @IBOutlet weak var btn_deliverymenu: UIButton!
    var str_Day = ""
    var str_chawchawoption1 = ""
     var str_chawchawoption2 = ""
    var price = Float()
    var count : Int = 0
    var choiceoption = ""
    var countCheck = 0
    
    var droptick1 = "drop1"
    var droptick2 = "drop2"
    var isChecked: Bool = true
    var isChecked1: Bool = true
    
    @IBOutlet weak var view_Chawchaw: UIView!
    var arr_chawchawdish = NSMutableArray()
    
    var dataChoiceOptionselected = [DataChoiceOption]()
    var dataChoiceOptionIndex: Int = -1
    var isChoiceOption1: Bool = false

    var Indexpathhh : Int = 0
    var countValue : String!
    
    var int_Plus = [String]()
    
    @IBOutlet weak var collectionView_category: UICollectionView!
    var arr_DayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
   
   var modelMain:DeliveryMenu?
   var tappedDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         view_Chawchaw.isHidden = true
          view_black.isHidden = true
        
        
        for _ in 0 ..< 5{
        }
        //
     //   lbl_countcart.text = "0"
        
        self.navigationController?.isNavigationBarHidden = true
        view_Menutab.layer.cornerRadius = view_Menutab.layer.frame.height/2
        view_Menutab.layer.borderWidth = 1
        view_Menutab.layer.borderColor = (UIColor .white).cgColor
        view_Menutab.clipsToBounds = true
       
        view_tab.layer.shadowColor = UIColor.lightGray.cgColor
        view_tab.layer.shadowOpacity = 5.0
        view_tab.layer.shadowRadius = 5.0
        view_tab.layer.shadowOffset = CGSize (width: 1.5, height: 1.5)
        view_tab.layer.masksToBounds = false
        view_tab.layer.cornerRadius = 5.0
        
        view_Chawchaw.layer.shadowColor = UIColor.lightGray.cgColor
        view_Chawchaw.layer.shadowOpacity = 5.0
        view_Chawchaw.layer.shadowRadius = 5.0
        view_Chawchaw.layer.shadowOffset = CGSize (width: 1.5, height: 1.5)
        view_Chawchaw.layer.masksToBounds = false
        view_Chawchaw.layer.cornerRadius = 5.0
        
        
        
        scrollView.delegate = self
        
         tbl_Cart.tableFooterView = UIView()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                scrollView.contentSize = CGSize(width: 320, height: 750)
            case 1334:
                print("iPhone 6/6S/7/8")
                scrollView.contentSize = CGSize(width: 375, height: 870)
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                scrollView.contentSize = CGSize(width: 375, height: 960)
            case 2436:
                print("iPhone X")
                scrollView.contentSize = CGSize(width: 375, height: 1065)
            default:
                print("unknown")
            }
        }
        
        print(UserModel.sharedInstance.auth_Key)
        
        //Don't call service if we have already data from server until checkout
        //Clear this data from utility after checkout
        if let model=Utility.getDeliveryMenuModel(){
            self.modelMain=model
            saveDataForCart()
        }else{
            self.getDeliveryMenuList()
        }
        
        img_cart.layer.cornerRadius = img_cart.layer.frame.height/2
        img_cart.layer.borderWidth = 1
        img_cart.layer.borderColor = (UIColor .init(red: 189.0/255.0, green: 89.0/255.0, blue: 49.0/255.0, alpha: 1)).cgColor
        img_cart.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    
    func getDeliveryMenuList() {
        
        let setparameters = ["access_token":UserModel.sharedInstance.auth_Key] as [String : Any]
        print(setparameters)
        let str_FullUrl = "menu/delivery-menu"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
        print("str_FullUrl is:-",str_FullUrl)
        
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL(str_FullUrl, params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        let lStatus = tempDict.value(forKey: "success") as! Bool
                                        
                                        if lStatus == true {
                                            
                                            let dict_Data = tempDict["data"] as! NSDictionary
                                            print("dict_Data is:-",dict_Data)
                                           // self.dict_Delivery_Menu = dict_Data["delivery_menu"] as! [String:Any]
                                            
                                            //Model initialization
                                            if let deliveryMenu=dict_Data["delivery_menu"] as? [String:Any]
                                            {
                                                self.modelMain=DeliveryMenu(fromDictionary: deliveryMenu)
                                                Utility.setDeliveryMenuModel(deliveryModel: self.modelMain)
                                                self.saveDataForCart()
                                            }
                                            self.tbl_Cart.reloadData()
                                          }else{
                                            // Somethign wrong
                                            
                                        }
                                        
                                        
        }) { (error) in
            print(error.localizedDescription)
            CommenModel.showDefaltAlret(strMessage:error.localizedDescription, controller: self)
            AutoBcmLoadingView.dismiss()
        }
    }
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func cart_Action(_ sender: Any)
    {
      
       
        
        let CartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        if (self.saveDataForCart(shouldReturn:true) != nil) {
            CartVC.tempArr = self.saveDataForCart(shouldReturn:true)!
        }
        self.navigationController?.pushViewController(CartVC, animated: false)
    }
    @IBAction func blackhide_Action(_ sender: Any)
    {
        view_Chawchaw.isHidden = true
        view_black.isHidden = true
    }
    @IBAction func orders_Action(_ sender: Any)
    {
        let OrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        if (self.saveDataForCart(shouldReturn:true) != nil) {
           OrdersVC.tempArr = self.saveDataForCart(shouldReturn:true)!
        }
        
        self.navigationController?.pushViewController(OrdersVC, animated: false)
    }
    
    @IBAction func account_Action(_ sender: Any)
    {
        let AccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        if (self.saveDataForCart(shouldReturn:true) != nil) {
              AccountVC.tempArr = self.saveDataForCart(shouldReturn:true)!
        }
        self.navigationController?.pushViewController(AccountVC, animated: false)
    }
    
    @IBAction func restaurant_Action(_ sender: Any)
    {
        btn_restaurantmenu.setTitleColor(UIColor.white, for: .normal)
        btn_deliverymenu.setTitleColor(UIColor.lightGray, for: .normal)
        self.lbl_comingssoon.isHidden = false
        self.tbl_Cart.isHidden = true
    }
    
    @IBAction func delivery_Action(_ sender: Any)
    {
        btn_deliverymenu.setTitleColor(UIColor.white, for: .normal)
        btn_restaurantmenu.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.lbl_comingssoon.isHidden = true
        self.tbl_Cart.isHidden = false
        
    }
    
    //    MARK:- tableView's methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        guard self.modelMain != nil else {return 0}
        if tableView == self.tbl_Cart
        {
             return 3 // first for Deliver menu, Second for chawchaw option one and third for chawchaw option second
        }
        else
        {
            return 1
        }
     }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: // deliver menu section
            return 0
        case 1,2: // chawchaw option section
            return 61
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: // deliver menu section
            return nil
        case 1: // chawchaw option one
            let CartListOption1 = tableView.dequeueReusableCell(withIdentifier: "CartListOption1") as! CartListOption1
            
            CartListOption1.arrowButton.addTarget(self, action: #selector(self.arrow1Action(_:)), for: .touchUpInside)
            
            if droptick1 == "drop1"
            {
                let image = UIImage (named: "up_arrow.png")
                CartListOption1.arrowButton.setImage(image, for: .normal)
            }
            else
            {
                let image = UIImage (named: "down_arrow.png")
                CartListOption1.arrowButton.setImage(image, for: .normal)
            }
            
            if (self.modelMain?.chawchawOption1.count)! > 0
            {
                let model   =   self.modelMain?.chawchawOption1[0]
                CartListOption1.lbl_dishname.text = model?.shortDescription
                let price44 =  Float(truncating: model?.price as! NSNumber)
                print(price44)
               let price55 =  String(price44)
               CartListOption1.lbl_quantity.text  =   "GH₵ " + price55
                
            }
            return CartListOption1
        case 2:// chawchaw option two
            let CartListOption1 = tableView.dequeueReusableCell(withIdentifier: "CartListOption2") as! CartListOption2
            
            CartListOption1.arrowButton.addTarget(self, action: #selector(self.arrow2Action(_:)), for: .touchUpInside)
            
            if droptick2 == "drop2"
            {
                let image = UIImage (named: "up_arrow.png")
                CartListOption1.arrowButton.setImage(image, for: .normal)
            }
            else
            {
                let image = UIImage (named: "down_arrow.png")
                CartListOption1.arrowButton.setImage(image, for: .normal)
            }
            
            if (self.modelMain?.chawchawOption2.count)! > 0
            {
                let model   =   self.modelMain?.chawchawOption2[0]
                CartListOption1.lbl_dishname.text = model?.shortDescription
                let price4 =  Float(truncating: model?.price as! NSNumber)
                 print(price4)
                let price5 = String(price4)
                CartListOption1.lbl_quantity.text  =   "GH₵ " + price5
                
            }
            return CartListOption1
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        if tableView == self.tbl_Cart
        {
                    if indexPath.section==0 //Delivery menu cell
                    {
                        guard let arrModel = getModelForSelectedDay() else {return 125}
                        let model = arrModel[indexPath.row]
                        
                        if model.isChoice==1{
                            return 247
                        }
                        return 125
                    }
                    else if indexPath.section==1 // chawchaw option 1
                    {
                        
                        if droptick1 == "drop1"
                        {
                            return 0
                        }
                        else
                        {
                            return 52
                       }
                        
                        
                    }
                    else if indexPath.section==2// chawchaw option 2
                    {
                        
                        if droptick2 == "drop2"
                        {
                            return 0
                        }
                        else
                        {
                            return 52
                      }
                    }
                   
                    else
                    {
                        return 52
                    }
        }
        else
        {
            
              return 44
        }
    }
    func getModelForSelectedDay()->[FridayMenu]?{
        var model:[FridayMenu]?
        switch tappedDay{
        case 0: model   =   self.modelMain?.mondayMenu
        case 1: model   =   self.modelMain?.tuesdayMenu
        case 2: model   =   self.modelMain?.wednesdayMenu
        case 3: model   =   self.modelMain?.thursdayMenu
        case 4: model   =   self.modelMain?.fridayMenu
        default : break
        }
        return model
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.tbl_Cart
        {
                    if section==0 //Delivery menu
                    {
                        let arrModel   =   getModelForSelectedDay()
                        return arrModel?.count ?? 0
                    }
                    else if section==1 //chawchaw option 1
                    {
                        
                        
                        if droptick1 == "drop1"
                        {
                            return 0
                        }
                        else
                        {
                           return self.modelMain?.chawchawOption1.count ?? 0
                        }
                    }
                    else if section==2 //chawchaw option 2
                    {
                        
                        
                        if droptick2 == "drop2"
                        {
                            return 0
                        }
                        else
                        {
                            return self.modelMain?.chawchawOption2.count ?? 0
                        }
                    }
                    else
                    {
                        return 0
                    }
        }
       else
        {
                 return dataChoiceOptionselected.count

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == self.tbl_Cart
        {
                        if indexPath.section==0 //Delivery menu
                        {
                            
                            guard let arrModel = getModelForSelectedDay() else {return UITableViewCell()}
                            let model = arrModel[indexPath.row]
                            
                            if model.isChoice==1{
                                return getCartCheckBoxListCell(tableView: tableView, cellForRowAt: indexPath, model: model)
                            }
                            return getCartListCell(tableView: tableView,cellForRowAt: indexPath, model: model)
                            
                        }
                        else if indexPath.section==1{ //Chachaw option 1
                           
                            let CartListOption1Details = tableView.dequeueReusableCell(withIdentifier: "CartListOption1Details", for: indexPath) as! CartListOption1Details
                            
                            let model   =   self.modelMain?.chawchawOption1[indexPath.row]
                            
                            CartListOption1Details.actionButton.tag = indexPath.row
                            CartListOption1Details.actionButton.addTarget(self, action: #selector(self.ListOption1Action(_:)), for: .touchUpInside)
                            
            
                            
                           // CartListOption1Details.actionButton.setTitle((self.arrChwSubMenu[0] as! NSArray)[indexPath.row] as? String,for: .normal)
                            let optionIndex = model?.dataChoiceOptions.index{$0.isSelected == true}
                            CartListOption1Details.actionButton.setTitle(model?.dataChoiceOptions[optionIndex!].options,for: .normal)
                            CartListOption1Details.lbl_dishname.text = model?.title
                            
                            CartListOption1Details.btn_plus.tag = indexPath.row
                            CartListOption1Details.btn_plus.addTarget(self, action: #selector(self.btnIncrementChawChawOptionOneItemClicked(_:)), for: .touchUpInside)
                            CartListOption1Details.btn_minus.tag = indexPath.row
                            CartListOption1Details.btn_minus.addTarget(self, action: #selector(self.btnDecrementChawChawOptionOneItemClicked(_:)), for: .touchUpInside)
                            
                            CartListOption1Details.lbl_counting.text = String(format: "%d", model?.cartValue ?? 0)
                            return CartListOption1Details
                        }
                        else //if indexPath.section==2 //Chachaw option 2
                        {
                            let CartListOption2Details = tableView.dequeueReusableCell(withIdentifier: "CartListOption2Details", for: indexPath) as! CartListOption2Details
                         
                            CartListOption2Details.actionButton.tag = indexPath.row
                            CartListOption2Details.actionButton.addTarget(self, action: #selector(self.ListOption2Action(_:)), for: .touchUpInside)
                            
                             let model   =   self.modelMain?.chawchawOption2[indexPath.row]
                            
                           // CartListOption2Details.actionButton.setTitle((self.arrChwSubMenu[1] as! NSArray)[indexPath.row] as? String,for: .normal)
                            let optionIndex = model?.dataChoiceOptions.index{$0.isSelected == true}
                            CartListOption2Details.actionButton.setTitle(model?.dataChoiceOptions[optionIndex!].options,for: .normal)
                            
                            CartListOption2Details.btn_plus.tag = indexPath.row
                            CartListOption2Details.btn_plus.addTarget(self, action: #selector(self.btnIncrementChawChawOptionTwoItemClicked(_:)), for: .touchUpInside)
                            CartListOption2Details.btn_minus.tag = indexPath.row
                            CartListOption2Details.btn_minus.addTarget(self, action: #selector(self.btnDecrementChawChawOptionTwoItemClicked(_:)), for: .touchUpInside)
                            
                            CartListOption2Details.lbl_dishname.text = model?.title
                            
                            CartListOption2Details.lbl_counting.text = String(format: "%d", model?.cartValue ?? 0)
                            return CartListOption2Details
                        }
        }
        else
        {
            
          
                let Cellchawchawlist1 = tableView.dequeueReusableCell(withIdentifier: "Cellchawchawlist", for: indexPath) as! Cellchawchawlist
                
                Cellchawchawlist1.lbl_dish.text = dataChoiceOptionselected[indexPath.row].options
                return Cellchawchawlist1
                
         
        }
    }
    func getCartListCell( tableView: UITableView,cellForRowAt indexPath: IndexPath,model:FridayMenu?) -> UITableViewCell{
        var cell_Add = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartListCell
        
        cell_Add.btn_plus.tag = indexPath.row
        cell_Add.btn_plus.addTarget(self, action: #selector(self.btnIncrementCartListItemClicked(_:)), for: .touchUpInside)
        
        
        cell_Add.btn_minus.tag = indexPath.row
        cell_Add.btn_minus.addTarget(self, action: #selector(self.btnDecrementCartListItemClicked(_:)), for: .touchUpInside)
        
        let imgWidth = cell_Add.img_order.layer.frame.width
        let imgHeight = cell_Add.img_order.layer.frame.height
        
        cell_Add.img_order.layer.cornerRadius = cell_Add.img_order.layer.frame.height/2
        cell_Add.img_order.clipsToBounds = true
        
        price =  Float(truncating: model?.price as! NSNumber)
        let price1 = String(price)
        
        cell_Add.lbl_counting.text = String(format: "%d", model?.cartValue ?? 0)
        
        let str_UserImage = model?.image
        cell_Add.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
        
        cell_Add.lbl_dishname.text = model?.title
        cell_Add.lbl_quantity.text  =   "GH₵ " + price1
        cell_Add.lbl_description.text = model?.descriptionField
        
        return cell_Add
    }
    func getCartCheckBoxListCell( tableView: UITableView,cellForRowAt indexPath: IndexPath,model:FridayMenu?) -> UITableViewCell{
       
        let cell_Addlistcheckbox = tableView.dequeueReusableCell(withIdentifier: "CartListCheckboxCell", for: indexPath) as! CartListCheckboxCell
        
        let price2 =  Float(truncating: model?.price as! NSNumber)
        let price3 = String(price2)
        cell_Addlistcheckbox.lbl_dishname.text = model?.title
        cell_Addlistcheckbox.lbl_choicetext.text = model?.choiceText
        cell_Addlistcheckbox.lbl_quantity.text  =   "GH₵ " + price3
        
        
        let substrings = model?.choiceOptions!.split(separator: ",")
    
        let firstBit = substrings?[0]
        let secondBit = substrings?[1]
        let thirdBit = substrings?[2]
        
        cell_Addlistcheckbox.lbl1.text = String(firstBit ?? "")
        cell_Addlistcheckbox.lbl2.text = String(secondBit ?? "")
        cell_Addlistcheckbox.lbl3.text = String(thirdBit ?? "")
        
        cell_Addlistcheckbox.btn_plus.tag = indexPath.row
        cell_Addlistcheckbox.btn_plus.addTarget(self, action: #selector(self.btnIncrementCartListItemClicked(_:)), for: .touchUpInside)
        
        cell_Addlistcheckbox.btn_minus.tag = indexPath.row
        cell_Addlistcheckbox.btn_minus.addTarget(self, action: #selector(self.btnDecrementCartListItemClicked(_:)), for: .touchUpInside)
        
        cell_Addlistcheckbox.lbl_counting.text = String(format: "%d", model?.cartValue ?? 0)
       
        if (model?.dataChoiceOptions.count)! >= 3{
            if (model?.dataChoiceOptions[0].isSelected)! { cell_Addlistcheckbox.box1.setCheckState(.checked, animated: false) }
            else{
                cell_Addlistcheckbox.box1.setCheckState(.unchecked, animated: false)
            }
            if (model?.dataChoiceOptions[1].isSelected)! { cell_Addlistcheckbox.box2.setCheckState(.checked, animated: false) }
            else{
                cell_Addlistcheckbox.box2.setCheckState(.unchecked, animated: false)
            }
            if (model?.dataChoiceOptions[2].isSelected)! { cell_Addlistcheckbox.box3.setCheckState(.checked, animated: false) }
            else {
                cell_Addlistcheckbox.box3.setCheckState(.unchecked, animated: false)
            }
        }
        cell_Addlistcheckbox.box1.addTarget(self, action: #selector(checkbox1ValueChanged(_:)), for: .valueChanged)
        cell_Addlistcheckbox.box1.tag=indexPath.row
        cell_Addlistcheckbox.box2.addTarget(self, action: #selector(checkbox2ValueChanged(_:)), for: .valueChanged)
        cell_Addlistcheckbox.box2.tag=indexPath.row
        cell_Addlistcheckbox.box3.addTarget(self, action: #selector(checkbox3ValueChanged(_:)), for: .valueChanged)
        cell_Addlistcheckbox.box3.tag=indexPath.row
        
        return cell_Addlistcheckbox
    }
    
    @objc func actionButtonPressed(_ sender: UIButton, withMenu menu: DropDown) {
        menu.show()
       // self.tbl_Cart.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == self.tbl_Cart
        {

        }
        else
        {
            let indexPath = IndexPath(row:indexPath.row, section: 0)
            
        
            
        
          let stringmodal = dataChoiceOptionselected[indexPath.row].options
            
            if isChoiceOption1 {
                for dic in  (self.modelMain?.chawchawOption1[dataChoiceOptionIndex].dataChoiceOptions)! {
                    dic.isSelected = false;
                }
                
                self.modelMain?.chawchawOption1[dataChoiceOptionIndex].dataChoiceOptions[indexPath.row].isSelected = true;
         
            } else {
                for dic in  (self.modelMain?.chawchawOption2[dataChoiceOptionIndex].dataChoiceOptions)! {
                    dic.isSelected = false;
                }
                self.modelMain?.chawchawOption2[dataChoiceOptionIndex].dataChoiceOptions[indexPath.row].isSelected = true;
            }
         
        
            print(stringmodal ?? "")
            
            tbl_Cart.reloadData()
            view_Chawchaw.isHidden = true
            view_black.isHidden = true
            
        }
    }
    
    
    
    @objc func arrow1Action(_ sender: UIButton)
    {
    
        if isChecked == true
        {
            isChecked = false
            droptick1 = ""
            tbl_Cart.reloadData()
            
           
        } else
        {
            isChecked = true
            droptick1 = "drop1"
            tbl_Cart.reloadData()
        }
     
        
    }
    @objc func arrow2Action(_ sender: UIButton)
    {
        
       //  droptick2 = ""
        // tbl_Cart.reloadData()
        
        if isChecked1 == true
        {
            isChecked1 = false
            droptick2 = ""
            tbl_Cart.reloadData()
            
            
        } else
        {
            isChecked1 = true
            droptick2 = "drop2"
            tbl_Cart.reloadData()
        }
        
    }
    @objc func ListOption1Action(_ sender: UIButton)
    {
       
        view_Chawchaw.isHidden = false
         view_black.isHidden = false

       dataChoiceOptionselected = (self.modelMain?.chawchawOption1[sender.tag].dataChoiceOptions)!
        dataChoiceOptionIndex = sender.tag;
        isChoiceOption1 = true;
        self.tbl_chawchaw.reloadData()
        
    }
    @objc func ListOption2Action(_ sender: UIButton)
    {
        
        view_Chawchaw.isHidden = false
        view_black.isHidden = false
        
        dataChoiceOptionselected = (self.modelMain?.chawchawOption2[sender.tag].dataChoiceOptions)!
        dataChoiceOptionIndex = sender.tag;
        isChoiceOption1 = false;

        self.tbl_chawchaw.reloadData()
 
    }
    @objc func btnIncrementCartListItemClicked(_ sender: UIButton){
        //cart item  is in section 0
        let arrModel=getModelForSelectedDay()

        arrModel?[sender.tag].cartValue = (arrModel?[sender.tag].cartValue ?? 0) + 1
    
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListCell{
            cell.lbl_counting.text = String(format: "%d", arrModel?[sender.tag].cartValue ?? 0)
        }
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListCheckboxCell{
            cell.lbl_counting.text = String(format: "%d", arrModel?[sender.tag].cartValue ?? 0)
        }
       _ =  saveDataForCart()
    }

    @objc func btnDecrementCartListItemClicked(_ sender: UIButton){
        //cart item  is in section 0
        let arrModel=getModelForSelectedDay()
        var cartValue = arrModel?[sender.tag].cartValue
        cartValue = (cartValue ?? 0) - 1
        if (cartValue ?? 0) < 0{
            cartValue = 0
        }
        arrModel?[sender.tag].cartValue = cartValue
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListCell{
            cell.lbl_counting.text = String(format: "%d", arrModel?[sender.tag].cartValue ?? 0)
        }
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListCheckboxCell{
            cell.lbl_counting.text = String(format: "%d", arrModel?[sender.tag].cartValue ?? 0)
        }
        _ =  saveDataForCart()
    }
    @objc func btnIncrementChawChawOptionOneItemClicked(_ sender: UIButton){
        //chaw chaw option 1 is in section 1
        self.modelMain?.chawchawOption1[sender.tag].cartValue = (self.modelMain?.chawchawOption1[sender.tag].cartValue ?? 0) + 1
        let indexPath = IndexPath(row: sender.tag, section: 1)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListOption1Details{
            cell.lbl_counting.text = String(format: "%d", self.modelMain?.chawchawOption1[sender.tag].cartValue ?? 0)
        }
        _ =  saveDataForCart()
    }
    @objc func btnDecrementChawChawOptionOneItemClicked(_ sender: UIButton){
        //chaw chaw option 1 is in section 1
        
        var cartValue = self.modelMain?.chawchawOption1[sender.tag].cartValue
        cartValue = (cartValue ?? 0) - 1
        if (cartValue ?? 0) < 0{
            cartValue = 0
        }
   //     arrModel?[sender.tag].cartValue = cartValue
        
        
        self.modelMain?.chawchawOption1[sender.tag].cartValue = cartValue
        
        //self.modelMain?.chawchawOption1[sender.tag].cartValue = (self.modelMain?.chawchawOption1[sender.tag].cartValue ?? 0) - 1
        let indexPath = IndexPath(row: sender.tag, section: 1)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListOption1Details{
            cell.lbl_counting.text = String(format: "%d", self.modelMain?.chawchawOption1[sender.tag].cartValue ?? 0)
        }
        _ =  saveDataForCart()
    }
    @objc func btnIncrementChawChawOptionTwoItemClicked(_ sender: UIButton){
        //chaw chaw option 2 is in section 2
        self.modelMain?.chawchawOption2[sender.tag].cartValue = (self.modelMain?.chawchawOption2[sender.tag].cartValue ?? 0) + 1
        let indexPath = IndexPath(row: sender.tag, section: 2)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListOption2Details{
            cell.lbl_counting.text = String(format: "%d", self.modelMain?.chawchawOption2[sender.tag].cartValue ?? 0)
        }
        _ =  saveDataForCart()
    }
    @objc func btnDecrementChawChawOptionTwoItemClicked(_ sender: UIButton){
        //chaw chaw option 2 is in section 2
        
        var cartValue = self.modelMain?.chawchawOption2[sender.tag].cartValue
        cartValue = (cartValue ?? 0) - 1
        if (cartValue ?? 0) < 0{
            cartValue = 0
        }
        
        self.modelMain?.chawchawOption2[sender.tag].cartValue = cartValue
        let indexPath = IndexPath(row: sender.tag, section: 2)
        if let cell = tbl_Cart.cellForRow(at: indexPath) as? CartListOption2Details{
            cell.lbl_counting.text = String(format: "%d", self.modelMain?.chawchawOption2[sender.tag].cartValue ?? 0)
        }
       _ =   saveDataForCart()
    }
    func saveDataForCart(shouldReturn:Bool=false)->NSMutableArray?{
        //Set modified model to user further
        Utility.setDeliveryMenuModel(deliveryModel: self.modelMain)
        var arrCartDataForWeekDay=self.modelMain?.mondayMenu.filter{return $0.cartValue>0}
        
        if let arr=self.modelMain?.tuesdayMenu.filter({return $0.cartValue>0}) {
          arrCartDataForWeekDay?.append(contentsOf: arr)
        }
        if let arr=self.modelMain?.wednesdayMenu.filter({return $0.cartValue>0}) {
            arrCartDataForWeekDay?.append(contentsOf: arr)
        }
        if let arr=self.modelMain?.thursdayMenu.filter({return $0.cartValue>0}) {
            arrCartDataForWeekDay?.append(contentsOf: arr)
        }
        if let arr=self.modelMain?.fridayMenu.filter({return $0.cartValue>0}) {
            arrCartDataForWeekDay?.append(contentsOf: arr)
        }
        
        let arrChawChawOptionOneSelected=self.modelMain?.chawchawOption1.filter{return $0.cartValue>0}
        let arrChawChawOptionTwoSelected=self.modelMain?.chawchawOption2.filter{return $0.cartValue>0}
        
        if arrChawChawOptionOneSelected != nil || arrChawChawOptionTwoSelected != nil
        {
            let total=(arrCartDataForWeekDay?.count)! + (arrChawChawOptionOneSelected?.count)! +  (arrChawChawOptionTwoSelected?.count)!
            lbl_countcart.text=String(format: "%d", total )
            
            let highscore = String(format: "%d", total )
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(highscore, forKey: "highscore")
            userDefaults.synchronize() // don't forget this!!!!
            
            if shouldReturn{
                let arrTemp=NSMutableArray()
                for item in arrCartDataForWeekDay!{
                    arrTemp.add(item.toDictionary())
                }
                for item in arrChawChawOptionOneSelected!{
                    arrTemp.add(item.toDictionary())
                }
                for item in arrChawChawOptionTwoSelected!{
                    arrTemp.add(item.toDictionary())
                }
                return arrTemp
            }
        }
        
        return nil
    }
    //     MARK: - CollectionView's methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arr_DayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCategoryCell", for: indexPath) as! CollectionCategoryCell
        str_Day = arr_DayList[indexPath.row]
        
        cell.img_line.isHidden = true
        cell.lbl_category.text = str_Day
        cell.img_line.isHidden = tappedDay == indexPath.row ? false : true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // get data according to day in dictionary
        tappedDay = indexPath.row
        tbl_Cart.reloadData()
        collectionView_category.reloadData()
    }
    
    @IBAction func checkbox1ValueChanged(_ sender: M13Checkbox) {
        //cart item  is in section 0
        guard let arrModel=getModelForSelectedDay() else {return}
        let model=arrModel[sender.tag]
        let arrSelected=model.dataChoiceOptions.filter{return $0.isSelected}
        guard model.dataChoiceOptions.count >= 3 else {return}
        if sender.checkState == .checked{
            guard arrSelected.count < 2 else { sender.setCheckState(.unchecked, animated: true);return}//only two can be selected
        }
        model.dataChoiceOptions[0].isSelected = !model.dataChoiceOptions[0].isSelected
        if model.dataChoiceOptions[0].isSelected{
            sender.setCheckState(.checked, animated: true)
        }else{
            sender.setCheckState(.unchecked, animated: true)
        }
    }
    
    @IBAction func checkbox2ValueChanged(_ sender: M13Checkbox) {
        //cart item  is in section 0
        guard let arrModel=getModelForSelectedDay() else {return}
        let model=arrModel[sender.tag]
        let arrSelected=model.dataChoiceOptions.filter{return $0.isSelected}
        guard model.dataChoiceOptions.count >= 3 else {return}
        
        if sender.checkState == .checked{
            guard arrSelected.count < 2 else { sender.setCheckState(.unchecked, animated: true);return}//only two can be selected
        }
        
        model.dataChoiceOptions[1].isSelected = !model.dataChoiceOptions[1].isSelected
        if model.dataChoiceOptions[1].isSelected{
            sender.setCheckState(.checked, animated: true)
        }else{
            sender.setCheckState(.unchecked, animated: true)
        }
    }
    
    @IBAction func checkbox3ValueChanged(_ sender: M13Checkbox) {
        //cart item  is in section 0
        print("sender state \(sender.checkState.rawValue)")
        guard let arrModel=getModelForSelectedDay() else {return}
        let model=arrModel[sender.tag]
        let arrSelected=model.dataChoiceOptions.filter{return $0.isSelected}

        guard model.dataChoiceOptions.count >= 3 else {return} // There must be atleast 3 options
        
        if sender.checkState == .checked{
            guard arrSelected.count < 2 else { sender.setCheckState(.unchecked, animated: true);return}//only two can be selected
        }
        
        model.dataChoiceOptions[2].isSelected = !model.dataChoiceOptions[2].isSelected
        if model.dataChoiceOptions[2].isSelected{
            sender.setCheckState(.checked, animated: true)
        }else{
            sender.setCheckState(.unchecked, animated: true)
        }
    }
    
}
