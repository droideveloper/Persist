//
//  Persist+Data.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public extension Persist {
	
	static func save(_ data: Data, to directory: Directory, with path: String) -> Completable {
		return Completable.create { _ in
			do {
			let url = try createIfNotExists(for: path, in: directory)
			try data.write(to: url, options: .atomic)
			} catch {
				#if DEBUG
					print(error)
				#endif
			}
			return Disposables.create()
		}
	}
	
	static func retrieve(_ path: String, from directory: Directory) -> Observable<Data> {
		return Observable.create { observer in
			do {
				let url = try checkIfExists(for: path, in: directory)
				let data = try Data(contentsOf: url)
				observer.on(.next(data))
				observer.on(.completed)
			} catch {
				observer.on(.error(error))
			}
			return Disposables.create()
		}
	}
}
