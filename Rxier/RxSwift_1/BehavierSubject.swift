//
//  BehavierSubject.swift
//  Rxier
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import RxSwift

/**
* BehaviorSubject は最後の値を覚えていて、subscribeすると即座にそれを最初に通知する Subject
*/
struct BehavierSubjectPresenter {
	private let buttonHiddenSubject = BehaviorSubject(value: false)
	var buttonHidden: Observable<Bool> { return buttonHiddenSubject }
	
	func start() {
		buttonHiddenSubject.onNext(true)
	}
	
	func pause() {
		buttonHiddenSubject.onNext(false)
	}
	
	func stop() {
		buttonHiddenSubject.onCompleted()
	}
	
	func getValue() -> Bool? {
		do {
			return try buttonHiddenSubject.value()
		} catch let error {
			print(error)
			return nil
		}
	}
}
