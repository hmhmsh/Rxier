//: Playground - noun: a place where people can play

import UIKit
import RxSwift

/**
* merge を使うと、２つの同じ型のイベントストリームを１つにまとめることができます。
*/
struct Hoge {
	private let valueSubject = PublishSubject<Int>()
	var value: Observable<Int> { return valueSubject }
	
	func setValue(value: Int) {
		valueSubject.onNext(value)
	}
}

struct Foo {
	private let valueSubject = PublishSubject<Int>()
	var value: Observable<Int> { return valueSubject }

	func setValue(value: Int) {
		valueSubject.onNext(value)
	}
}

let hoge = Hoge()
let foo = Foo()
var mergeEvent: Observable<Int> { return Observable.of(hoge.value, foo.value).merge() }
let mergeDisposable = mergeEvent.subscribe(onNext: { (value) in
	// 変更があった方の値が通知される
	// どちらのObservableが更新されたかは知れない
	print(value)
})
hoge.setValue(value: 0)
foo.setValue(value: 1)
mergeDisposable.dispose()

/**
* combineLatest は（違う型でも可の）直近の最新値同士を組み合わせたイベントを作ります。
*/
struct Huga {
	private let strSubject = PublishSubject<String>()
	var str: Observable<String> { return strSubject }
	
	func setStr(str: String) {
		strSubject.onNext(str)
	}
}

let huga = Huga()
var combineLatestEvent: Observable<String> { return Observable.combineLatest(hoge.value, huga.str, resultSelector: { (value, str) -> String in
	return "\(str)_\(value)"
})}
let combineLatestDisposable = combineLatestEvent.subscribe(onNext: {
	// 更新があったら、更新がなかった方の値は最新が使われる
	print("combine latest: \($0)")
})
huga.setStr(str: "値は")
hoge.setValue(value: 0)
hoge.setValue(value: 1)
combineLatestDisposable.dispose()

