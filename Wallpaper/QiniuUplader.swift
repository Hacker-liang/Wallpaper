//
//  QiniuUplader.swift
//  Wallpaper
//
//  Created by langren on 2020/7/10.
//  Copyright © 2020 langren. All rights reserved.
//

import UIKit
import Photos

class QiniuHelper: NSObject {
    func uploadLivePhoto(livePhoto: PHLivePhoto) {
        let uploader = QNUploadManager()
        let asset = PHAssetResource.assetResources(for: livePhoto)
        let option = QNUploadOption()
        let authPolicy = QiniuAuthPolicy("5v-livephotos", expires: 10000)
        let token = authPolicy.makeToken(accessKey: "cBqs-TLzssggrz5-ZGjjvkLrQieW2p1njCVHMf7Y", secretKey: "uq9fYW-EI-GdalJhr1a8_96GaRUNtPwUs-PKUbTQ")
        
        uploader?.putFile(Bundle.main.path(forResource: "test", ofType: "mov"), key: "test", token: token, complete: { (info, str, dic) in
            print(str)
            
        }, option: nil)
    }
}

final class QiniuAuthPolicy {
   /// 七牛上的文件路径
   let scope: String
   /// token 过期时间,
   let expires: Int

   static let `default` = QiniuAuthPolicy()
   ///
   ///
   /// - Parameters:
   ///   - scope: 文件路径
   ///   - expires: token过期时间, 默认 3600
   init(_ scope: String = "heicarbook", expires: Int = 3600) {
       self.scope = scope
       self.expires = expires
   }
   
   /// 根据accessKey,secretKey 获取 token
   ///
   /// - Parameters:
   ///   - accessKey: accessKey
   ///   - secretKey: secretKey
   /// - Returns: token
   func makeToken(accessKey: String, secretKey: String) -> String {
       
       let secretKeyStr = secretKey.cString(using: .utf8)
       
       let policy = paramsToJson()
       
       guard let policyData = policy.data(using: .utf8) else {
           return ""
       }
       guard let encodedPolicy = QN_GTM_Base64.string(byWebSafeEncoding: policyData, padded: true) else {
           return ""
       }
       
       guard let encodedPolicyStr = encodedPolicy.cString(using: .utf8) else {
           return ""
       }
       let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 20)
    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretKeyStr, strlen(secretKeyStr ?? []), encodedPolicyStr, strlen(encodedPolicyStr), result)
       let resultData = Data(bytes: result, count: 20)
       let encodedDigest = QN_GTM_Base64.string(byWebSafeEncoding: resultData, padded: true) ?? ""
       
       let token = "\(accessKey):\(encodedDigest):\(encodedPolicy)"
       print("七牛 toekn ==> \(token)")
       return token
   }
   /// 参数转 json
   private func paramsToJson() -> String {
       var deadline: time_t = 0
       time(&deadline)
       deadline += expires > 0 ? expires : 3600
       let dict: [String: Any] = ["scope": scope, "deadline": deadline]
       if !JSONSerialization.isValidJSONObject(dict) {
           return ""
       } else {
           guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
               return ""
           }
           let json = String(data: data, encoding: .utf8)
           return json ?? ""
       }
   }
}
