//
//  File.swift
//  CVUploader
//
//  Created by Trum Gyorgy on 2017. 02. 14..
//  Copyright © 2017. Trum Gyorgy. All rights reserved.
//

import Foundation

class CustomFile {
    
    var name : String
    var fileType : String
    var url : URL
    var serverTypeName : String

    
    init(name: String, fileType: String, url: URL, serverType: String)
    {
        self.name = name
        self.fileType = fileType
        self.url = url
        self.serverTypeName = serverType
    }
}
