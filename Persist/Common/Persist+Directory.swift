//
//  Persist+Directory.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public extension Persist {
	
	static var fileManager: FileManager {
		get {
			return FileManager.default
		}
	}
	
	static func newUrl(for path: String?, in directory: Directory) throws -> URL {
		var searchPath: FileManager.SearchPathDirectory
		switch directory {
			case .document:
				searchPath = .documentDirectory
			case .cache:
				searchPath = .cachesDirectory
			case .applicationSupport:
				searchPath = .applicationDirectory
			case .temporary:
				guard var url = URL(string: NSTemporaryDirectory()) else {
					throw NSError(domain: "",
												code: -1,
												userInfo: nil)
				}
				url = url.sanityPathCheck(path: path, isDirectory: false)
				url = url.sanityProtocolCheck()
				return url
			case .shared(let name):
				guard var url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: name) else {
					throw NSError(domain: "",
												code: -1,
												userInfo: nil)
				}
				url = url.sanityPathCheck(path: path, isDirectory: false)
				url = url.sanityProtocolCheck()
				return url
		}
		guard var url = fileManager.urls(for: searchPath, in: .userDomainMask).first else {
			throw NSError(domain: "",
										code: -1,
										userInfo: nil)
		}
		url = url.sanityPathCheck(path: path, isDirectory: false)
		url = url.sanityProtocolCheck()
		return url
	}
	
	static func checkIfExists(for path: String, in directory: Directory) throws -> URL {
		let url = try newUrl(for: path, in: directory)
		if fileManager.fileExists(atPath: url.path) {
			return url
		}
		throw NSError(domain: "",
									code: -1,
									userInfo: nil)
	}
	
	static func createIfNotExists(for path: String, in directory: Directory) throws -> URL {
		let url = try newUrl(for: path, in: directory)
		let dir = url.deletingLastPathComponent()
		if !fileManager.fileExists(atPath: dir.path) {
			try fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
		}
		return url
	}
}
