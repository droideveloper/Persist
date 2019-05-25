//
//  ImagePersistance.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public protocol ImagePersistance {
	
	func write(image: UIImage, to file: File) -> Completable
	func read(from file: File) -> Observable<UIImage>
	
	func writeAsync(image: UIImage, to file: File) -> Disposable
	func readAsync(from file: File, success: @escaping (UIImage) -> Void) -> Disposable
	func readAsync(from file: File, success: @escaping (UIImage) -> Void, error: @escaping (Error) -> Void) -> Disposable
}
