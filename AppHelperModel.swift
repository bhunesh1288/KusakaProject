//
//  AppHelperModel.swift
//  AUTOBCM


import UIKit
import Alamofire
import SystemConfiguration
import MobileCoreServices


class AppHelperModel: NSObject {

    class func requestGETURL(_ strURL: String, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void) {
        
        let url = Constants.BASE_URL + strURL
        
        Alamofire.request(url).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let response = responseObject.result.value!
                success(response as AnyObject)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestDownloadPdf(_ strUrl:String , success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        
        Alamofire.download(strUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil, to: destination).response { (response) in
            if (response.error != nil) {
                print("error")
                failure(response.error!)
            }
            else {
                success(response.destinationURL?.absoluteString as AnyObject)
            }
        }
        
    }
    
    class func requestGETHEADERURL(_ strURL : String, headers : [String : String]?, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        
        let url = Constants.BASE_URL + strURL
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let response = responseObject.result.value!
                success(response as AnyObject)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        
        let url = Constants.BASE_URL + strURL
        
        print(url)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                let response = responseObject.result.value!
                success(response as AnyObject)
            }
            if responseObject.result.isFailure {
                
                let error : Error = responseObject.result.error!
                let code =  responseObject.response?.statusCode

                if code == 404 {
                    let errorTemp = NSError(domain:"notFound", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 401 {
                    let errorTemp = NSError(domain:"invalidCredentials", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 400 {
                    let errorTemp = NSError(domain:"invalidRequest", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 500 {
                    let errorTemp = NSError(domain:"notFound", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)

                }else {
                   failure(error)
                }
            }
        }
    }
    
    
    class func requestFromFullPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        
        let url = Constants.BASE_URL + strURL
        
        print(url)
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            if responseObject.result.isSuccess {
                let response = responseObject.result.value!
                success(response as AnyObject)
            }
            if responseObject.result.isFailure {
                
                let error : Error = responseObject.result.error!
                let code =  responseObject.response?.statusCode
                
                if code == 404 {
                    let errorTemp = NSError(domain:"notFound", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 401 {
                    let errorTemp = NSError(domain:"invalidCredentials", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 400 {
                    let errorTemp = NSError(domain:"invalidRequest", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                }else if code == 500 {
                    let errorTemp = NSError(domain:"notFound", code:(responseObject.response?.statusCode)!, userInfo:nil)
                    failure(errorTemp)
                    
                }else {
                    failure(error)
                }
            }
        }
    }
    
    class func mimeTypeForPath (pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
       // return "application/octet-stream"
        return "application/octet-stream"
    }
    class func requestUploadVideo (_ strURL : String, params : [String : AnyObject], headers : [String : String]?,fileDetail: NSMutableArray?, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        let url = strURL
        Alamofire.upload(multipartFormData: { multipartFormData in
            for i in (0..<fileDetail!.count) {
                let dic_WC = fileDetail?[i] as! NSDictionary
                let fileData = dic_WC["filedata"] as! Data
                let fileName = dic_WC["upload_key"] as! String
                let file_extension = dic_WC["pathExtension"] as! String
                let mimeType = self.mimeTypeForPath(pathExtension: file_extension)
                // multipartFormData.append(fileData, withName: fileName, fileName: fileName, mimeType: mimeType)
                let imageImage = "filename."+file_extension
                multipartFormData.append(fileData, withName: fileName, fileName: imageImage, mimeType: mimeType)
                
            }
            for (key, value) in params {
                multipartFormData.append((value.data(using:String.Encoding.utf8.rawValue))!, withName: key)
            }}, to: url, method: .post, headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print(response.result) // result of response serialization
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                success(JSON as AnyObject)
                            }
                            else{
                                print("ffsf")
                            }
                        }
                    case .failure(let encodingError):
                        failure(encodingError)
                        break
                    }
        })
    }
    class func requestUploadFile(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?,fileDetail: NSMutableArray?, success:@escaping (AnyObject) -> Void, failure:@escaping (Error) -> Void){
        let url = Constants.BASE_URL + strURL
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for i in (0..<fileDetail!.count) {
                let dic_WC = fileDetail?[i] as! NSDictionary
                let fileData = dic_WC["filedata"] as! Data
                let fileName = dic_WC["upload_key"] as! String
                let file_extension = dic_WC["pathExtension"] as! String
                let mimeType = self.mimeTypeForPath(pathExtension: file_extension)
                // multipartFormData.append(fileData, withName: fileName, fileName: fileName, mimeType: mimeType)
                let imageImage = "filename."+file_extension
                multipartFormData.append(fileData, withName: fileName, fileName: imageImage, mimeType: mimeType)
                
            }
            
            for (key, value) in params! {
                multipartFormData.append((value.data(using:String.Encoding.utf8.rawValue))!, withName: key)
                
            }}, to: url, method: .post, headers: headers,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print(response.result)     // result of response serialization
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                success(JSON as AnyObject)
                            }
                            else{
                                print("error in json responce")
                                failure(response.error!)
                            }
                        }
                    case .failure(let encodingError):
                        failure(encodingError)
                        break
                    }
        })
    }
}
