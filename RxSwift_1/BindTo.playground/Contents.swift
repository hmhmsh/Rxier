//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

/**
* Subject や Variable は Observable の bindTo メソッドの引数として渡せます。
* この bindTo を使うと subscribe を使うより少し簡単にイベントをプロパティに接続できます。
*/
struct Presenter {
	private let buttonHiddenRelay = BehaviorRelay(value: false)
	var buttonHidden: Observable<Bool> { return buttonHiddenRelay.asObservable() }
	
	func start() {
		buttonHiddenRelay.accept(true)
	}
	
	func pause() {
		buttonHiddenRelay.accept(false)
	}
}


let button = UIButton()
let presenter = Presenter()

/**
* subscribe pattern
*/
let disposable = presenter.buttonHidden.subscribe(onNext: { (hidden) in
	button.isHidden = hidden
	print(button.isHidden)
})

/**
* bindTo pattern
*/
let disposable2 = presenter.buttonHidden.bind(to: button.rx.isHidden)


presenter.start()
presenter.pause()
disposable.dispose()
disposable2.dispose()

/**
* 自分で作成したプロパティにbindToで接続する
*/
struct Hoge {
	var isHidden = BehaviorRelay(value: true)
	
	init() {
		isHidden.subscribe(onNext: { (hidden) in
			print("create myself: \(hidden)")
		})
	}
}

let hoge = Hoge()
let disposable3 = presenter.buttonHidden.bind(to: hoge.isHidden)

presenter.start()
presenter.pause()
disposable3.dispose()

