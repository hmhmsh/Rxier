//: Playground - noun: a place where people can play

import UIKit
import RxSwift

/**
* BehaviorSubject の薄いラッパーで、onError を発生させる必要がないなら、BehaviorSubject を Variable に置き換えられます。
* BehaviorSubject と違ってonError / onCompleted を明示的に発生させることはできないため、現在値取得で例外が発生することはありません。
* 特に意識することはないかもしれませんが、Variable オブジェクトは自身が解放されるときに onCompleted を発行します。
*/

/**
* [DEPRECATED] `Variable` is planned for future deprecation. Please consider `BehaviorRelay` as a replacement. Read more at: git.io/vNqvx
*/
//struct Presenter {
//	private let buttonHiddenVariable = Variable(false)
//	var buttonHidden: Observable<Bool> { return buttonHiddenVariable.asObservable() }
//
//	func start() {
//		buttonHiddenVariable.value = true
//	}
//
//	func pause() {
//		buttonHiddenVariable.value = false
//	}
//
//	func stop() {
//		// 明示的にonError・onCompletedは呼べない
////		buttonHiddenVariable.onCompleted()
//	}
//
//	func getValue() -> Bool? {
//		do {
//			return try buttonHiddenVariable.value
//		} catch let error {
//			print(error)
//			return nil
//		}
//	}
//}

import RxCocoa
struct Presenter {
	private let buttonHiddenRelay = BehaviorRelay(value: false)
	var buttonHidden: Observable<Bool> { return buttonHiddenRelay.asObservable() }
	
	func start() {
		buttonHiddenRelay.accept(true)
	}
	
	func pause() {
		buttonHiddenRelay.accept(false)
	}
	
	func stop() {
		// 明示的にonError・onCompletedは呼べない
		// buttonHiddenRelay.onCompleted()
	}
	
	func getValue() -> Bool {
		return buttonHiddenRelay.value
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
