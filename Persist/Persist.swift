//
//  Persist.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public class Persist: DataPeristance, ImagePersistance, CodablePersistance {
	
	public static var `default`: Persist {
		get {
			return instance
		}
	}
	
	public static var `data`: DataPeristance {
		get {
			return `default`
		}
	}
	
	public static var `image`: ImagePersistance {
		get {
			return `default`
		}
	}
	
	public static var `codable`: CodablePersistance {
		get {
			return `default`
		}
	}

	private static let instance = Persist(fileManager: .default)
	
	private let fileManager: FileManager
	private let decoder: JSONDecoder
	private let encoder: JSONEncoder
	
	// parameters can be changed by user needs
	private init(fileManager: FileManager, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
		self.fileManager = fileManager
		self.encoder = encoder
		self.decoder = decoder
	}
	
	public func encodingStrategies(outputFormating: JSONEncoder.OutputFormatting? = nil,
																 dateEncoding: JSONEncoder.DateEncodingStrategy? = nil,
																 dataEncoding: JSONEncoder.DataEncodingStrategy? = nil,
																 nonConformingFloatEncoding: JSONEncoder.NonConformingFloatEncodingStrategy? = nil,
																 keyEncoding: JSONEncoder.KeyEncodingStrategy? = nil) {
		encoder.outputFormatting = outputFormating ?? encoder.outputFormatting
		encoder.dateEncodingStrategy = dateEncoding ?? encoder.dateEncodingStrategy
		encoder.dataEncodingStrategy = dataEncoding ?? encoder.dataEncodingStrategy
		encoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncoding ?? encoder.nonConformingFloatEncodingStrategy
		encoder.keyEncodingStrategy = keyEncoding ?? encoder.keyEncodingStrategy
	}
	
	public func decodingStrategies(dateDecoding: JSONDecoder.DateDecodingStrategy? = nil,
																 dataDecoding: JSONDecoder.DataDecodingStrategy? = nil,
																 nonConformingFloatDecoding: JSONDecoder.NonConformingFloatDecodingStrategy? = nil,
																 keyDecoding: JSONDecoder.KeyDecodingStrategy? = nil) {
		decoder.dateDecodingStrategy = dateDecoding ?? decoder.dateDecodingStrategy
		decoder.dataDecodingStrategy = dataDecoding ?? decoder.dataDecodingStrategy
		decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecoding ?? decoder.nonConformingFloatDecodingStrategy
		decoder.keyDecodingStrategy = keyDecoding ?? decoder.keyDecodingStrategy
	}
	
	// write Data
	public func write(data: Data, to file: File) -> Completable {
		let fileManager = self.fileManager
		return Completable.create { observer in
			do {
				let uri = try file.url(fileManager: fileManager)
				try data.write(to: uri, options: .atomic)
				observer(.completed)
			} catch {
				observer(.error(error))
			}
			return Disposables.create()
		}
	}
	
	public func writeAsync(data: Data, to file: File) -> Disposable {
		return write(data: data, to: file)
			.subscribeOn(Schedulers.io)
			.subscribe()
	}
	
	// read Data
	public func read(from file: File) -> Observable<Data> {
		let fileManager = self.fileManager
		return Observable.create { observer in
			do {
				let uri = try file.url(fileManager: fileManager)
				if let path = file.path {
					let allowedToRead = fileManager.fileExists(atPath: path)
					if !allowedToRead {
						throw PersistError.iilegalIO(name: file.name)
					}
				}
				let data = try Data(contentsOf: uri)
				observer.on(.next(data))
				observer.on(.completed)
			} catch {
				observer.on(.error(error))
			}
			return Disposables.create()
		}
	}
	
	public func readAsync(from file: File, success: @escaping (Data) -> Void) -> Disposable {
		let dataSource: Observable<Data> = read(from: file)
		return dataSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success)
	}
	
	public func readAsync(from file: File, success: @escaping (Data) -> Void, error: @escaping (Error) -> Void) -> Disposable {
		let dataSource: Observable<Data> = read(from: file)
		return dataSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success, onError: error)
	}
	
	// write UIImage
	public func write(image: UIImage, to file: File) -> Completable {
		if let data = image.pngData() {
			return write(data: data, to: file)
		} else if let data = image.jpegData(compressionQuality: 0.85) {
			return write(data: data, to: file)
		} else {
			return Completable.create { observer in
				observer(.error(PersistError.illegalType(type: "only .png or .jpg supported")))
				return Disposables.create()
			}
		}
	}
	
	public func writeAsync(image: UIImage, to file: File) -> Disposable {
		return write(image: image, to: file)
			.subscribeOn(Schedulers.io)
			.subscribe()
	}
	
	// read UIImage
	public func read(from file: File) -> Observable<UIImage> {
		let fileManager = self.fileManager
		let source: Observable<Data> = read(from: file)
		return source.concatMap { data -> Observable<UIImage> in
			if let path = file.path {
				let allowedToRead = fileManager.fileExists(atPath: path)
				if !allowedToRead {
					throw PersistError.iilegalIO(name: file.name)
				}
			}
			if let image = UIImage(data: data) {
				return Observable.just(image)
			}
			return Observable.error(PersistError.illegalType(type: "\(String(describing: UIImage.self))"))
		}
	}
	
	public func readAsync(from file: File, success: @escaping (UIImage) -> Void) -> Disposable {
		let imageSource: Observable<UIImage> = read(from: file)
		return imageSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success)
	}
	
	public func readAsync(from file: File, success: @escaping (UIImage) -> Void, error: @escaping (Error) -> Void) -> Disposable {
		let imageSource: Observable<UIImage> = read(from: file)
		return imageSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success, onError: error)
	}
	
	// write Encodable
	public func write<T: Encodable>(value: T, to file: File) -> Completable {
		let encoder = self.encoder
		let source = Observable.just(value)
		return source.flatMap { [weak weakSelf = self] value -> Completable in
			do {
				let data = try encoder.encode(value)
				return weakSelf?.write(data: data, to: file) ?? Completable.never()
			} catch {
				return Completable.error(error)
			}
		}.asCompletable()
	}
	
	public func writeAsync<T>(data: T, to file: File) -> Disposable where T : Encodable {
		return write(value: data, to: file)
			.subscribeOn(Schedulers.io)
			.subscribe()
	}
	
	// read Decodable
	public func read<T: Decodable>(from file: File) -> Observable<T> {
		let decoder = self.decoder
		let fileManager = self.fileManager
		let source: Observable<Data> = read(from: file)
		return source.concatMap { data -> Observable<T> in
			do {
				if let path = file.path {
					let allowedToRead = fileManager.fileExists(atPath: path)
					if !allowedToRead {
						throw PersistError.iilegalIO(name: file.name)
					}
				}
				let value = try decoder.decode(T.self, from: data)
				return Observable.just(value)
			} catch {
				return Observable.error(error)
			}
		}
	}
	
	public func readAsync<T>(from file: File, success: @escaping (T) -> Void) -> Disposable where T : Decodable {
		let dataSource: Observable<T> = read(from: file)
		return dataSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success)
	}
	
	public func readAsync<T>(from file: File, success: @escaping (T) -> Void, error: @escaping (Error) -> Void) -> Disposable where T : Decodable {
		let dataSource: Observable<T> = read(from: file)
		return dataSource.subscribeOn(Schedulers.io)
			.subscribe(onNext: success, onError: error)
	}
}
