//
//  PersistError.swift
//  Persist
//
//  Created by Fatih Şen on 24.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public enum PersistError: Error, CustomStringConvertible {
	
	case illegalAccess(url: String)
	case illegalType(type: String)
	case iilegalIO(name: String)
	
	public var description: String {
		switch self {
			case .illegalAccess(let url):
				return "\(url) is not accessible by current context"
			case .illegalType(let type):
				return "\(type) can not be converterd"
			case .iilegalIO(let file):
				return "\(file) not exists"
		}
	}
}
