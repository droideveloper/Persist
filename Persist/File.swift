//
//  File.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation

public struct File: Equatable {
	
	var folder: Folder
	var path: String? = nil
	var name: String
	
	public func newFile(name: String) -> File {
			return File(folder: self.folder, path: self.path, name: name)
	}
	
	public func url(fileManager: FileManager) throws -> URL {
		var search: FileManager.SearchPathDirectory
		switch folder {
			case .document:
				search = .documentDirectory
			case .cache:
				search = .cachesDirectory
			case .applicationSupport:
				search = .applicationSupportDirectory
			case .shared(let name):
				guard var uri = fileManager.containerURL(forSecurityApplicationGroupIdentifier: name) else {
					throw PersistError.illegalAccess(url: "\(name)")
				}
				uri = try uri.checkPathSanity(path: path, name: name)
				uri = try uri.checkLocalFileSanity()
				return uri
			case .temporary:
				guard var uri = URL(string: NSTemporaryDirectory()) else {
					throw PersistError.illegalAccess(url: "\(NSTemporaryDirectory())")
				}
				uri = try uri.checkPathSanity(path: path, name: name)
				uri = try uri.checkLocalFileSanity()
				return uri
		}
		guard var uri = fileManager.urls(for: search, in: .userDomainMask).first else {
			throw PersistError.illegalAccess(url: "\(search)")
		}
		uri = try uri.checkPathSanity(path: path, name: name)
		uri = try uri.checkLocalFileSanity()
		return uri
	}

	public static func create(_ folder: Folder = .document, path: String? = nil, name: String) -> File {
		return File(folder: folder, path: path, name: name)
	}
	
	public static func ==(lhs: File, rhs: File) -> Bool {
		return lhs.folder == rhs.folder && lhs.path == rhs.path && lhs.name == rhs.name
	}
}
