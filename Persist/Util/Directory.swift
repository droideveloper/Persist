//
//  Directory.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public enum Directory: Equatable, CustomStringConvertible {
	
	case document
	case cache
	case applicationSupport
	case temporary
	case shared(name: String)
	
	public var description: String {
		switch self {
			case .document: return Constants.DIR_DOCUMENT
			case .cache: return Constants.DIR_CACHE
			case .applicationSupport: return Constants.DIR_APPLICATION_SUPPORT
			case .temporary: return Constants.DIR_TEMPORARY
			case .shared(let name): return "\(name)"
		}
	}
	
	public static func ==(lhs: Directory, rhs: Directory) -> Bool {
		switch (lhs, rhs) {
			case (.document, .document), (.cache, .cache), (.applicationSupport, .applicationSupport), (.temporary, .temporary):
				return true
		case (let .shared(name: n1), let .shared(name: n2)):
			return n1 == n2
			default:
				return false
		}
	}
}
