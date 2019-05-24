//
//  URL+Common.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public extension URL {
	
	func checkLocalFileSanity() throws -> URL {
		let filePrefix = Constants.PREF_FILE
		let prefix = absoluteString.lowercased().prefix(filePrefix.count)
		if prefix != filePrefix {
			if let uri = URL(string: filePrefix + absoluteString) {
				return uri
			}
			throw PersistError.illegalAccess(url: "\(filePrefix + absoluteString)")
		}
		return self
	}
	
	func checkPathSanity(path: String?) throws -> URL {
		guard let path = path else {
			return self
		}
		return self.appendingPathComponent(path, isDirectory: true)
	}
}
