//
//  CommenModel.swift
//  AUTOBCM
//
//  Created by vishnu jangid on 08/02/18.
//  Copyright © 2018 brsoftech. All rights reserved.
//

import UIKit
import SystemConfiguration
import MobileCoreServices

class CommenModel: NSObject {
    
    class  func setObjectWithUserDefault(object:Any , keyName:String)  {
        UserDefaults.standard.set(object, forKey: keyName)
    }
    class  func getObjectWithUserDefault(key:String) -> Any {
        return UserDefaults.standard.value(forKey: key) as Any
    }
    class func removeObjectWithUserDefault(key:String)  {
        return UserDefaults.standard.removeObject(forKey:key)
    }
    
    class func showDefaltAlret(strMessage : String, controller : UIViewController){
        
        let alertMessage = UIAlertController(title:"KUSAKA", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
       
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            NotificationCenter.default.post(name: Notification.Name("OkTapped"), object: nil)
        }))
        controller.present(alertMessage, animated: true, completion: nil)
    }
    
   class func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    class func popVCAlert(strMessage : String, controller : UIViewController){
        
        let alertMessage = UIAlertController(title:"KUSAKA", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            controller.navigationController?.popViewController(animated: true)
        }))
        controller.present(alertMessage, animated: true, completion: nil)
    }
    
    
    class func getHeader() -> [String:String]
    {
        let dic = NSMutableDictionary()
        if let getuserDetails = CommenModel.getObjectWithUserDefault(key: "UserDetails") as? NSMutableDictionary
        {
            let username = getuserDetails["email"] as! String
            let password = getuserDetails["password"] as! String
            print(username)
            print(password)
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            dic.setObject("Basic \(base64Credentials)", forKey: "Authorization" as NSCopying)
        }
        return dic as! [String : String]
    }
    class  func setbuttonBorder(button:UIButton)  {
        //UIButton set border
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius =  button.layer.frame.height / 2 + 10
        button.clipsToBounds = true
    }
    class func setBorderOnView(sender:UIView) -> UIView {
        sender.layer.shadowColor = UIColor.lightGray.cgColor
        sender.layer.shadowOpacity = 0.7
        sender.layer.shadowOffset = CGSize(width: 0, height: 0)
        sender.layer.cornerRadius = CGFloat(3.0)
        sender.layer.borderColor = UIColor.lightGray.cgColor
        sender.layer.borderWidth = 1.0
        sender.clipsToBounds = true
        return sender
    }
    class func setCircle(sender:Any) {
        (sender as AnyObject).layer.cornerRadius = 0.5 * (sender as AnyObject).bounds.size.width
        if((sender as AnyObject).isKind(of: UIButton.self)){
            (sender as! UIButton).clipsToBounds = true
        }
        if((sender as AnyObject).isKind(of: UITextField.self)){
            (sender as! UITextField).clipsToBounds = true
        }
    }
    
    class func isConnetctedToInternet () -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    
    
    class func mimeTypeForPath(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    class func jsonParse(jsonString:String) -> AnyObject {
        let data: NSData = jsonString.data(using: String.Encoding.utf8)! as NSData
        do {
            let parseJSON = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            return parseJSON as AnyObject
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        return NSArray()
    }
    class func arrayToJSONstring(array:AnyObject) -> String{
        var sendingvalue=String()
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Do this for print data only otherwise skip
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                //print(JSONString)
                sendingvalue = String(JSONString.characters.filter { !" \n\t\r".characters.contains($0) })
                //print(sendingvalue)
            }
        } catch {
        }
        
        return sendingvalue
    }
    
    class func getTempFilePath(_ fileName: String) -> String {
        assert(fileName != "", "fileName is nil in +(NSString*)getTempFilePath:(NSString*)fileName")
        assert((fileName.count) > 0, "fileName is empty in +(NSString*)getTempFilePath:(NSString*)fileName")
        let tempFilePath = "\(NSTemporaryDirectory())\(fileName)"
        return tempFilePath
    }
    
    class func deleteFile(atPath filePath: String) {
        assert(filePath != "", "filePath is nil in +(void)deleteFileAtPath:(NSString*)filePath")
        assert((filePath.count ) > 0, "filePath is empty in +(void)deleteFileAtPath:(NSString*)filePath")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            var _: Error?
            if ((try? fileManager.removeItem(atPath: filePath)) != nil) {
                //Error - handle if requried
            }
        }
    }
}


extension Dictionary {
    func jsonString(dict : [String : AnyObject]) -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        return jsonString
    }
    
}
