//
//  Single+Threading.swift
//  Persist
//
//  Created by Fatih Şen on 15.02.2020.
//  Copyright © 2020 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

extension Single {
	
	public func async() -> PrimitiveSequence<Trait, Element> {
		return self.subscribeOn(Schedulers.io())
			.observeOn(Schedulers.mainThread())
	}
}
