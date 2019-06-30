//
//  AutoBcmLoadingView.swift
//  AUTOBCM
//


import Foundation
import SVProgressHUD

class AutoBcmLoadingView {
    
    static func show(_ message:String){
        
        SVProgressHUD .setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD .showProgress(-1, status: message)
    }
    
    static func dismiss(){
        SVProgressHUD.dismiss()
    }
}
