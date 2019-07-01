//
//  UserModel.swift
//  AUTOBCM


import UIKit

class UserModel: NSObject {
    
    var first_Name,last_Name,Email,auth_Key, login_Time, message, permissions_Update_Time, redirect,
    active_index,alternate_mobile_number,blood_group,city_id,cost_center,country_id,
    created_on,customer,customerId,designation,dob,employee_id,first_name,full_name,
    l_id,isExtStaff,isFirstLogin,isLdapUser,is_bcm_user,key,last_name,location_id,
    nationality,orgmap_id,password,personal_email,personal_mobile,pwd_exp_date,
    residential_address_1,residential_address_2,site,lstr_Status,updated_on,
    user_id, user_name,version,work_email,work_extension,work_mobile,
    work_phone:String
    
    var login_Status, status,   isDualAuth, reporting, state_id:Bool
    
    class var sharedInstance: UserModel {
        struct Static {
            static let instance: UserModel = UserModel()
        }
        return Static.instance
    }
    private override init(){
        self.auth_Key = ""
        self.first_Name = ""
        self.last_Name = ""
        self.Email = ""
        self.login_Time = ""
        self.message = ""
        self.permissions_Update_Time = ""
        self.redirect = ""
        self.active_index  = ""
        self.alternate_mobile_number = ""
        self.blood_group = ""
        self.city_id = ""
        self.cost_center = ""
        self.country_id = ""
        self.created_on = ""
        self.customer = ""
        self.customerId = ""
        self.designation = ""
        self.dob = ""
        self.employee_id = ""
        self.first_name = ""
        self.full_name = ""
        self.l_id = ""
        self.isExtStaff = ""
        self.isFirstLogin = ""
        self.isLdapUser = ""
        self.is_bcm_user = ""
        self.key = ""
        self.last_name = ""
        self.location_id = ""
        self.nationality = ""
        self.orgmap_id = ""
        self.password = ""
        self.personal_email = ""
        self.personal_mobile = ""
        self.pwd_exp_date = ""
        self.residential_address_1 = ""
        self.residential_address_2 = ""
        self.site = ""
        self.lstr_Status = ""
        self.updated_on = ""
        self.user_id = ""
        self.user_name = ""
        self.version = ""
        self.work_email = ""
        self.work_extension = ""
        self.work_mobile = ""
        self.work_phone = ""
        self.status = false
        self.state_id = false
        self.isDualAuth = false
        self.reporting = false
        self.login_Status = false

    }
    
    func updateUserDetails(lobjDict:NSDictionary) {
        
        print(lobjDict.count)
        
        if lobjDict.count > 0
        {
            print(lobjDict)
            
            let dict_Data = lobjDict["data"] as! NSDictionary
            print("dict_Data is:-",dict_Data)
            
            let user = dict_Data["user"] as! NSDictionary
            print("user is:-",user)
            
          //  self.login_Status = lobjDict.value(forKey: "Login_Status") as? Bool ?? false
            self.login_Status = lobjDict.value(forKey: "success") as? Bool ?? false
            self.login_Time = lobjDict.value(forKey: "Login_Time") as? String ?? ""
            
            self.auth_Key = lobjDict.value(forKey: "Login_Time") as? String ?? ""
            self.message = lobjDict.value(forKey: "message") as? String ?? ""
            
            self.auth_Key = user.value(forKey: "auth_key") as? String ?? ""
            self.first_Name = user.value(forKey: "first_name") as? String ?? ""
            self.last_Name = user.value(forKey: "last_name") as? String ?? ""
            self.Email = user.value(forKey: "email") as? String ?? ""
            
            print(self.auth_Key)
            
            
            self.permissions_Update_Time = lobjDict.value(forKey: "Permissions_Update_Time") as? String ?? ""
            self.redirect = lobjDict.value(forKey: "Redirect") as? String ?? ""
            self.status = lobjDict.value(forKey: "success") as? Bool ?? false
            
           self.active_index = lobjDict.value(forKey: "active_index") as? String ?? ""
            
            self.alternate_mobile_number = lobjDict.value(forKey: "alternate_mobile_number") as? String ?? ""
            self.blood_group = lobjDict.value(forKey: "blood_group") as? String ?? ""
            self.city_id = lobjDict.value(forKey: "city_id") as? String ?? ""
            self.cost_center = lobjDict.value(forKey: "cost_center") as? String ?? ""
            self.created_on = lobjDict.value(forKey: "created_on") as? String ?? ""
            self.customer = lobjDict.value(forKey: "customer") as? String ?? ""
            self.customerId = lobjDict.value(forKey: "customerId") as? String ?? ""
            
            if let value = lobjDict.value(forKey: "country_id") as? NSNumber
            {
                self.country_id = String(describing: value)
            }
            if let value = lobjDict.value(forKey: "designation") as? NSNumber
            {
                self.designation = String(describing: value)
            }
            self.dob = lobjDict.value(forKey: "dob") as? String ?? ""
            
            self.employee_id = lobjDict.value(forKey: "employee_id") as? String ?? ""
            self.first_name = lobjDict.value(forKey: "first_name") as? String ?? ""
            self.full_name = lobjDict.value(forKey: "full_name") as? String ?? ""
            
            if let value = lobjDict.value(forKey: "id") as? NSNumber {
                 self.l_id = String(describing: value)
            }
           
            self.isDualAuth = lobjDict.value(forKey: "success") as? Bool ?? false
            self.isExtStaff = lobjDict.value(forKey: "isExtStaff") as? String ?? ""
            self.isFirstLogin = lobjDict.value(forKey: "isFirstLogin") as? String ?? ""
            self.isLdapUser = lobjDict.value(forKey: "isLdapUser") as? String ?? ""
            self.is_bcm_user = lobjDict.value(forKey: "is_bcm_user") as? String ?? ""
            self.key = lobjDict.value(forKey: "key") as? String ?? ""
            
            self.last_name = lobjDict.value(forKey: "last_name") as? String ?? ""
            
            if let value = lobjDict.value(forKey: "location_id") as? NSNumber
            {
                self.location_id = String(describing: value)
            }
            if let value = lobjDict.value(forKey: "orgmap_id") as? NSNumber
            {
                self.orgmap_id = String(describing: value)
            }
            self.nationality = lobjDict.value(forKey: "nationality") as? String ?? ""
            self.password = lobjDict.value(forKey: "password") as? String ?? ""
            self.personal_email = lobjDict.value(forKey: "personal_email") as? String ?? ""
            self.personal_mobile = lobjDict.value(forKey: "personal_mobile") as? String ?? ""
            self.pwd_exp_date = lobjDict.value(forKey: "pwd_exp_date") as? String ?? ""
            self.reporting = lobjDict.value(forKey: "reporting") as? Bool ?? false
            self.residential_address_1 = lobjDict.value(forKey: "residential_address_1") as? String ?? ""
            self.residential_address_2 = lobjDict.value(forKey: "residential_address_2") as? String ?? ""
            self.site = lobjDict.value(forKey: "site") as? String ?? ""
            self.state_id = lobjDict.value(forKey: "state_id") as? Bool ?? false
            self.lstr_Status = lobjDict.value(forKey: "status") as? String ?? ""
            self.updated_on = lobjDict.value(forKey: "updated_on") as? String ?? ""
            
            
            
            self.user_id = lobjDict.value(forKey: "user_id") as? String ?? ""
            print(self.user_id)
            self.user_name = lobjDict.value(forKey: "user_name") as? String ?? ""
            self.work_email = lobjDict.value(forKey: "work_email") as? String ?? ""
            self.work_extension = lobjDict.value(forKey: "work_extension") as? String ?? ""

            if let value = lobjDict.value(forKey: "version") as? NSNumber
            {
                self.version = String(describing: value)
            }
            if let value = lobjDict.value(forKey: "work_mobile") as? String
            {
                self.work_mobile = String(describing: value)
            }
            if let value = lobjDict.value(forKey: "work_phone") as? String
            {
                self.work_phone = String(describing: value)
            }
            
        }
        
    }
}
