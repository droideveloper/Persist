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
	
	private static var ioInstance = {
		return ConcurrentDispatchQueueScheduler(qos: .userInitiated)
	}()
	
	private static var utilityInstance = {
		return ConcurrentDispatchQueueScheduler(qos: .utility)
	}()
	
	private static var backgroundInstance = {
		return ConcurrentDispatchQueueScheduler(qos: .background)
	}()
	
	private static var mainThreadInstance = {
		return MainScheduler.asyncInstance
	}()
	
	private init() {}
	
	public static func io() -> SchedulerType {
		return ioInstance
	}
	
	public static func utility() -> SchedulerType {
		return utilityInstance
	}
	
	public static func background() -> SchedulerType {
		return backgroundInstance
	}
	
	public static func mainThread() -> SchedulerType {
		return mainThreadInstance
	}
}
