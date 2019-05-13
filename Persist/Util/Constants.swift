//
//  Constants.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public class Constants {
	
	static let PREF_FILE = "file://"
	
	static let EXT_PNG = ".png"
	static let EXT_JPG = ".jpg"
	static let EXT_JPEG = ".jpeg"
	
	static let DIR_DOCUMENT = "<Application_Home>/Document"
	static let DIR_CACHE = "<Application_Home>/Cache"
	static let DIR_APPLICATION_SUPPORT = "<Application_Home>/Library/Application"
	static let DIR_TEMPORARY = "<Application_Home>/temp"
	
	
	static let CON_NOT_ACCESS_TEMPORARY_DIRECTORY = "can not access temperorary directory"
	static let CODE_TEMP_NOT_ALLOWED = 0x01
}
