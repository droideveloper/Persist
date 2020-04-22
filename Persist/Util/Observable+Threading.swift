//
//  Observable+Threading.swift
//  Persist
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
	
	public func async() -> Observable<E> {
		return self.subscribeOn(Schedulers.io())
			.observeOn(Schedulers.mainThread())
	}
}
