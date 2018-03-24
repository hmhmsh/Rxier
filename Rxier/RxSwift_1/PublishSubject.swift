//
//  PublishSubject.swift
//  Rxier
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import RxSwift

/**
* Subjectは、Observableでありつつ、イベントを発生させるための onNext/onError/onCompleted メソッドを提供
*/

struct PublishSubject_Hoge {
	// Subjectをprivateにする理由：外部からonNext()などを呼べないようにするため
	private let eventSubject = PublishSubject<Int>()
	
	// Observableを公開する
	var event: Observable<Int> { return eventSubject }
	
	func next(index: Int) {
		// イベントを通知するときは、Subject.onNext()を呼び出す
		eventSubject.onNext(index)
	}
}
