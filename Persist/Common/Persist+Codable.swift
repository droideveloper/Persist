//
//  Persist+Codable.swift
//  Persist
//
//  Created by Fatih Şen on 13.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public extension Persist {
	
	static func save<T: Codable>(_ value: T,to directory: Directory, with path: String, coder: JSONEncoder = JSONEncoder()) -> Completable {
		do {
			let data = try coder.encode(value)
			return save(data, to: directory, with: path)
		} catch {
			return Completable.error(error)
		}
	}
	
	static func retrieve<T: Codable>(_ path: String, from directory: Directory, type: T.Type, coder: JSONDecoder = JSONDecoder()) -> Observable<T> {
		let dataSource: Observable<Data> = retrieve(path, from: directory)
		return dataSource.concatMap { data -> Observable<T> in
			do {
				let value = try coder.decode(type, from: data)
				return Observable.of(value)
			} catch {
				return Observable.error(error)
			}
		}
	}
}
