//
//  String+Common.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public extension String {
	
	static var empty: String {
		get {
			return ""
		}
	}
	
	func toError(with code: Int?) -> NSError {
		return NSError(domain: self, code: code ?? -1, userInfo: nil)
	}
}
