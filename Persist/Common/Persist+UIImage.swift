//
//  Persist.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public extension Persist {
	
	static func save(_ image: UIImage, to directory: Directory, with path: String) -> Completable {
		let normalizedPath = path.lowercased()
		// png
		let pngRequested = normalizedPath.suffix(Constants.EXT_PNG.count) == Constants.EXT_PNG
		// jpg, jpeg
		let jpgRequested = normalizedPath.suffix(Constants.EXT_JPG.count) == Constants.EXT_JPG
			||	normalizedPath.suffix(Constants.EXT_JPEG.count) == Constants.EXT_JPEG
		
		if pngRequested {
			if let data = image.pngData() {
				return save(data, to: directory, with: path)
			}
		} else if jpgRequested {
			if let data = image.jpegData(compressionQuality: 1) {
				return save(data, to: directory, with: path)
			}
		}
		
		// it will provide error
		let error = NSError(domain: "", code: -1, userInfo: nil)
		return Completable.error(error)
	}
	
	static func retrieve(_ path: String, from directory: Directory) -> Observable<UIImage> {
		let dataSource: Observable<Data> = retrieve(path, from: directory)
		return dataSource.map { data in
				return UIImage(data: data) ?? UIImage() }

	}
}
