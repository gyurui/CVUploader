//
//  Document.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 14..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import Foundation

class Document {
    var uuid : String
    var size : Int
    var name : String
    var created : Int
    
    init(uuid : String, size : Int, name : String, created : Int)
    {
        self.uuid = uuid
        self.size = size
        self.name = name
        self.created = created
    }
}
