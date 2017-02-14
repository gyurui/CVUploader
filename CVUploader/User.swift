//
//  User.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 13..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import Foundation

class User
{
    var uuid : String
    var email : String
    var created : Int
    
    init(uuid: String, email: String, created: Int){
        self.uuid = uuid
        self.email = email
        self.created = created
    }
}
