//
//  URL+Sanity.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

extension URL {
	
	func sanityPathCheck(path: String?, isDirectory: Bool) -> URL {
		if let path = path {
			return self.appendingPathComponent(path, isDirectory: isDirectory)
		}
		return self
	}
	
	func sanityProtocolCheck() -> URL {
		let prefix = Constants.PREF_FILE
		let urlString = self.absoluteString.lowercased()
		if !urlString.starts(with: prefix) {
			guard let newUrl = URL(string: "\(prefix)\(urlString)") else {
				return self
			}
			return newUrl
		}
		return self
	}
	
	func sanityBackupCheck(is disabled: Bool) throws -> URL {
		var resourceUrl = self
		var values = URLResourceValues()
		values.isExcludedFromBackup = disabled
		try resourceUrl.setResourceValues(values)
		return resourceUrl
	}
}
