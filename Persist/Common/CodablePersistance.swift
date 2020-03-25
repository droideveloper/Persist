//
//  CodablePersistance.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public protocol CodablePersistance {
	
	// obj
	func write<T: Encodable>(value: T, to file: File) -> Completable
	func read<T: Decodable>(from file: File) -> Observable<T>
	
	func writeAsync<T: Encodable>(data: T, to file: File) -> Disposable
	func readAsync<T: Decodable>(from file: File, success: @escaping (T) -> Void) -> Disposable
	func readAsync<T: Decodable>(from file: File, success: @escaping (T) -> Void, error: @escaping (Error) -> Void) -> Disposable
	
	// array
	func write<T: Encodable>(value: [T], to file: File) -> Completable
	
	func writeAsync<T: Encodable>(data: [T], to file: File) -> Disposable
	func readAsync<T: Decodable>(from file: File, success: @escaping ([T]) -> Void) -> Disposable
	func readAsync<T: Decodable>(from file: File, success: @escaping ([T]) -> Void, error: @escaping (Error) -> Void) -> Disposable
}
