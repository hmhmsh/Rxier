//
//  CombineOperatorTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import XCTest
import RxSwift

class CombineOperatorTests: XCTestCase {
    
    func testMerge() {
        var expectedValue = 0
        let hoge = CombineOperatorHoge()
        let foo = CombineOperatorFoo()
        var mergeEvent: Observable<Int> { return Observable.of(hoge.value, foo.value).merge() }
        let mergeDisposable = mergeEvent.subscribe(onNext: { (value) in
            // 変更があった方の値が通知される
            // どちらのObservableが更新されたかは知れない
            XCTAssertEqual(expectedValue, value)
        })
        hoge.setValue(value: expectedValue)
        expectedValue = 1
        foo.setValue(value: expectedValue)
        mergeDisposable.dispose()
    }
    
    func testCombineLatest()  {
        var expectedString = ""
        var string = "値は"
        var value = 0
        
        let hoge = CombineOperatorHoge()
        let huga = CombineOperatorHuga()
        var combineLatestEvent: Observable<String> { return Observable.combineLatest(hoge.value, huga.str, resultSelector: { (value, str) -> String in
            // 更新があったら呼ばれる
            // 更新がなかった方の値は最新が使われる
            return "\(str)_\(value)"
        })}
        let combineLatestDisposable = combineLatestEvent.subscribe(onNext: {
            // 更新があったら呼ばれる
            XCTAssertEqual(expectedString, $0)
        })
        huga.setStr(str: string)
        expectedString = string + "_" + String(value)
        hoge.setValue(value: value)
        value = 1
        expectedString = string + "_" + String(value)
        hoge.setValue(value: value)
        combineLatestDisposable.dispose()
    }
    
    func testSample() {
        /**
         * sample はある Observable の値を発行するタイミングを、もう一方の Observable をトリガーして決める場合に使います。
         */
        var expectedValue = 0
        let hoge = CombineOperatorHoge()
        let huga = CombineOperatorHuga()
        let sampleDiposable = hoge.value.sample(huga.str.filter({ !$0.isEmpty })).subscribe(onNext: { (int) in
            // sample()の引数に渡したObservableに変更があった時にだけ呼ばれる(ここでは、hugaのstrが空文字列じゃない時)
            // 呼ばれた時に渡される値は、最初に指定したObservableの最新の値（ここでは、hoge.valueの最新の値）
            // sample()の引数に渡したObservableに変更があっても、最初に指定したObservableに変更がない場合は呼ばれない（hugaのstrに"tarou3"を指定したが、hogeのvalueは1から変わってないので呼ばれない）
            XCTAssertEqual(expectedValue, int)
        })
        
        hoge.setValue(value: expectedValue)
        huga.setStr(str: "")
        huga.setStr(str: "tarou")
        expectedValue = 1
        hoge.setValue(value: expectedValue)
        huga.setStr(str: "tarou2")
        huga.setStr(str: "tarou3")
        sampleDiposable.dispose()
    }
    
    func testWithLatestFrom() {
        /**
         * withLatestFrom は、ある Observable にもう一方の Observabe の最新値を合成します。
         */
        var expectedValue = 0
        let hoge = CombineOperatorHoge()
        let huga = CombineOperatorHuga()
        let withLatestFrom = huga.str.filter({ !$0.isEmpty }).withLatestFrom(hoge.value).subscribe(onNext: { (int) in
            // withLatestFrom()の引数に指定したObservableに変更がなくても、最初に指定したObservableに変更があった時だけ呼ばれる
            // 最初に指定したObservableの値に変更がなくても、値の代入がされたら呼ばれる
            XCTAssertEqual(expectedValue, int)
        })
        hoge.setValue(value: expectedValue)
        huga.setStr(str: "tarou")
        huga.setStr(str: "tarou2")
        huga.setStr(str: "tarou2")
        expectedValue = 1
        hoge.setValue(value: expectedValue)
        withLatestFrom.dispose()
    }
    
    func testWithLatestFrom2() {
        let string = "tarou"
        let value = 0
        let expectedString = string + "_" + String(value)

        let hoge = CombineOperatorHoge()
        let huga = CombineOperatorHuga()
        let withLatestFrom2 = huga.str.filter({ !$0.isEmpty }).withLatestFrom(hoge.value) { (str, int) -> String in
            // 2つの値を使用して、Observableを作ることが可能
            // 最初に指定したObservableに変更があった時だけ呼ばれる
            return "\(str)_\(int)"
            }
        let withLatestFrom2Disposable = withLatestFrom2.subscribe(onNext: { (str) in
                XCTAssertEqual(expectedString, str)
            })
        hoge.setValue(value: value)
        huga.setStr(str: string)
        withLatestFrom2Disposable.dispose()
    }
}

/**
 * merge を使うと、２つの同じ型のイベントストリームを１つにまとめることができます。
 */
struct CombineOperatorHoge {
    private let valueSubject = PublishSubject<Int>()
    var value: Observable<Int> { return valueSubject }
    
    func setValue(value: Int) {
        valueSubject.onNext(value)
    }
}

struct CombineOperatorFoo {
    private let valueSubject = PublishSubject<Int>()
    var value: Observable<Int> { return valueSubject }
    
    func setValue(value: Int) {
        valueSubject.onNext(value)
    }
}

/**
 * combineLatest は（違う型でも可の）直近の最新値同士を組み合わせたイベントを作ります。
 */
struct CombineOperatorHuga {
    private let strSubject = PublishSubject<String>()
    var str: Observable<String> { return strSubject }
    
    func setStr(str: String) {
        strSubject.onNext(str)
    }
}

