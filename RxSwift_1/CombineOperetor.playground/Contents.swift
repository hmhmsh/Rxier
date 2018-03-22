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
	// 更新があったら呼ばれる
	// 更新がなかった方の値は最新が使われる
	return "\(str)_\(value)"
})}
let combineLatestDisposable = combineLatestEvent.subscribe(onNext: {
	// 更新があったら呼ばれる
	print("combine latest: \($0)")
})
huga.setStr(str: "値は")
hoge.setValue(value: 0)
hoge.setValue(value: 1)
combineLatestDisposable.dispose()

/**
* sample はある Observable の値を発行するタイミングを、もう一方の Observable をトリガーして決める場合に使います。
*/
let sampleDiposable = hoge.value.sample(huga.str.filter({ !$0.isEmpty })).subscribe(onNext: { (int) in
	// sample()の引数に渡したObservableに変更があった時にだけ呼ばれる(ここでは、hugaのstrが空文字列じゃない時)
	// 呼ばれた時に渡される値は、最初に指定したObservableの最新の値（ここでは、hoge.valueの最新の値）
	// sample()の引数に渡したObservableに変更があっても、最初に指定したObservableに変更がない場合は呼ばれない（hugaのstrに"tarou3"を指定したが、hogeのvalueは1から変わってないので呼ばれない）
	print("sample: \(int)")
})

hoge.setValue(value: 0)
huga.setStr(str: "")
huga.setStr(str: "tarou")
hoge.setValue(value: 1)
huga.setStr(str: "tarou2")
huga.setStr(str: "tarou3")
sampleDiposable.dispose()

/**
* withLatestFrom は、ある Observable にもう一方の Observabe の最新値を合成します。
*/
let withLatestFrom = huga.str.filter({ !$0.isEmpty }).withLatestFrom(hoge.value).subscribe(onNext: { (int) in
	// withLatestFrom()の引数に指定したObservableに変更がなくても、最初に指定したObservableに変更があった時だけ呼ばれる
	// 最初に指定したObservableの値に変更がなくても、値の代入がされたら呼ばれる
	print("with latest from: \(int)")
})
hoge.setValue(value: 0)
huga.setStr(str: "tarou")
huga.setStr(str: "tarou2")
huga.setStr(str: "tarou2")
hoge.setValue(value: 1)
withLatestFrom.dispose()
