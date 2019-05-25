//
//  Schedulers.swift
//  Persist
//
//  Created by Fatih Şen on 25.05.2019.
//  Copyright © 2019 Fatih Şen. All rights reserved.
//

import Foundation
import RxSwift

public class Schedulers {
	
	public static let io = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
	public static let utility = ConcurrentDispatchQueueScheduler(qos: .utility)
	public static let background = ConcurrentDispatchQueueScheduler(qos: .background)
	
	private init() {}
}
