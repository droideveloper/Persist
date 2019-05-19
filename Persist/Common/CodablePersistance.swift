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
	
	func write<T: Encodable>(value: T, to file: File) -> Completable
	func read<T: Decodable>(from file: File, type: T.Type) -> Observable<T>
	
}
