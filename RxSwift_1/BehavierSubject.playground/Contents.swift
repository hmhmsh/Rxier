//: Playground - noun: a place where people can play

import UIKit
import RxSwift

/**
* BehaviorSubject は最後の値を覚えていて、subscribeすると即座にそれを最初に通知する Subject
*/
struct Presenter {
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

let presenter = Presenter()
let disposable = presenter.buttonHidden.subscribe(onNext: { (hidden) in
	print(hidden)
}, onCompleted: {
	print("comp")
})

presenter.start()
presenter.pause()
presenter.stop()
disposable.dispose()

presenter.getValue()
