//
//  PersistData.swift
//  Persist
//
//  Created by Fatih Şen on 15.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public protocol DataPeristance {
	
	func write(data: Data, to file: File) -> Completable
	func read(from file: File) -> Observable<Data>
}
