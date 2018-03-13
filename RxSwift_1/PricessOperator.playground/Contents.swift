//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

/**
* map はイベントの各要素を別の要素に変換します
*/
struct Action {
	let text = BehaviorRelay(value: "")
}

struct ActionPresenter {
	private let action = Action()
	var buttonEnabled: Observable<Bool> { return action.text.asObservable().map({ !$0.isEmpty }) }
	
	func some(text: String) {
		action.text.accept(text)
	}
}

let button = UIButton()
let actionPresenter = ActionPresenter()

actionPresenter.buttonEnabled.bind(to: button.rx.isEnabled)
print(button.isEnabled)

actionPresenter.some(text: "")
print(button.isEnabled)

actionPresenter.some(text: "you")
print(button.isEnabled)


/**
* filter は指定条件が true になるイベントだけを通過させます。
*/
struct Engine {
	private let runningBehavior = BehaviorRelay(value: false)
	var running: Observable<Bool> { return runningBehavior.asObservable() }
	
	func start() {
		runningBehavior.accept(true)
	}
}

struct EnginePresenter {
	private let engine = Engine()
	// 今回は、Boolを渡す必要がないため、mapでVoidに変換
	var startEngine: Observable<Void> { return engine.running.filter{ $0 }.map({ _ -> Void in }) }
	
	func start() {
		engine.start()
	}
}

let enginePresenter = EnginePresenter()
enginePresenter.startEngine.subscribe(onNext: {
	print("filter: start")
})
enginePresenter.start()
enginePresenter.start()


/**
* take はイベントを最初の指定した数だけに絞ります。指定数に達した時点で onCompleted になります。
*/
let enginePresenterTake = EnginePresenter()
enginePresenterTake.startEngine.take(1).subscribe(onNext: {
	print("take: start")
}, onCompleted: {
	// takeのcountを1にしたので、1回実行されたらonCompletedが呼ばれる
	print("take: completes")
})
print("take: start1")
enginePresenterTake.start()
print("take: start2")

/**
* skip はイベントの最初から指定個を無視します。
*/
let enginePresenterSkip = EnginePresenter()
enginePresenterSkip.startEngine.skip(2).subscribe(onNext: {
	// skipのcountを2にしたので、3回目以降の実行で呼ばれる
	print("skip: start")
})
print("skip: start1")
enginePresenterSkip.start()
print("skip: start2")
enginePresenterSkip.start()
print("skip: start3")
enginePresenterSkip.start()
