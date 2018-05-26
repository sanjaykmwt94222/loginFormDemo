//
//  UserInfo.swift
//  loginForm
//
//  Created by soc-lap-18 on 5/26/18.
//  Copyright © 2018 soc-lap-18. All rights reserved.
//

import Foundation
class UserInfo {
    var email: String = ""
    var name: String = ""
    var picture: String = ""
    
    init(data: [String:Any]){
        if let value = data["email"] as? String {
            self.email = value
        }
        if let value = data["name"] as? String {
            self.name = value
        }
        if let picture = data["picture"] as? [String:Any], let picData = picture["data"] as? [String:Any], let url = picData["url"] as? String {
            self.picture = url
        }

    }
}
