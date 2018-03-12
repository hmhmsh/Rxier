//: Playground - noun: a place where people can play

import UIKit
import RxSwift

var str = "Hello, playground"

struct Hoge {
	// Subjectをprivateにする理由：外部からonNext()などを呼べないようにするため
	private let eventSubject = PublishSubject<Int>()
	
	// Observableを公開する
	var event: Observable<Int> { return eventSubject }
	
	func some() {
		// イベントを通知するときは、Subject.onNext()を呼び出す
		eventSubject.onNext(1)
	}
}

// Usage
let hoge = Hoge.init()

// Observableのsubscribeを呼び出して、イベントを購読
let disposable = hoge.event.subscribe(onNext: { (index) in
	print(index)
}, onError: { (error) in
	print(error)
}, onCompleted: {
	print("completed")
})

hoge.some()
// 購読が必要なくなったら破棄
disposable.dispose()

