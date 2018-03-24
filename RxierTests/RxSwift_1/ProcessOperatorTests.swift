//
//  ProcessOperator.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import UIKit
import XCTest
import RxSwift
import RxCocoa

class ProcessOperatorTests: XCTestCase {
    
    func testMap() {
        let button = UIButton()
        let actionPresenter = ProcessOperatorActionPresenter()
        var expectedEnabled = false
        
        let mapDisposable = actionPresenter.buttonEnabled.bind(to: button.rx.isEnabled)
        XCTAssertEqual(expectedEnabled, button.isEnabled)
        
        expectedEnabled = false
        actionPresenter.some(text: "")
        XCTAssertEqual(expectedEnabled, button.isEnabled)

        expectedEnabled = true
        actionPresenter.some(text: "you")
        XCTAssertEqual(expectedEnabled, button.isEnabled)

        mapDisposable.dispose()
    }
    
    func testFilter() {
        let enginePresenter = ProcessOperatorEnginePresenter()
        let filterDisposable = enginePresenter.startEngine.subscribe(onNext: {
            XCTAssert(true)
        })
        enginePresenter.start()
        enginePresenter.start()
        filterDisposable.dispose()
    }
    
    func testTake() {
        /**
         * take はイベントを最初の指定した数だけに絞ります。指定数に達した時点で onCompleted になります。
         */
        let enginePresenterTake = ProcessOperatorEnginePresenter()
        let takeDisposable = enginePresenterTake.startEngine.take(1).subscribe(onNext: {
            XCTAssert(true)
        }, onCompleted: {
            // takeのcountを1にしたので、1回実行されたらonCompletedが呼ばれる
            XCTAssert(true)
        })
        enginePresenterTake.start()
        takeDisposable.dispose()
    }
    
    func testSkip() {
        /**
         * skip はイベントの最初から指定個を無視します。
         */
        let enginePresenterSkip = ProcessOperatorEnginePresenter()
        let skipDisposable = enginePresenterSkip.startEngine.skip(2).subscribe(onNext: {
            // skipのcountを2にしたので、3回目以降の実行で呼ばれる
            XCTAssert(true)
        })
        enginePresenterSkip.start()
        enginePresenterSkip.start()
        enginePresenterSkip.start()
        skipDisposable.dispose()
    }
}

/**
 * map はイベントの各要素を別の要素に変換します
 */
struct ProcessOperatorAction {
    let text = BehaviorRelay(value: "")
}

struct ProcessOperatorActionPresenter {
    private let action = ProcessOperatorAction()
    var buttonEnabled: Observable<Bool> { return action.text.asObservable().map({ !$0.isEmpty }) }
    
    func some(text: String) {
        action.text.accept(text)
    }
}

/**
 * filter は指定条件が true になるイベントだけを通過させます。
 */
struct ProcessOperatorEngine {
    private let runningBehavior = BehaviorRelay(value: false)
    var running: Observable<Bool> { return runningBehavior.asObservable() }
    
    func start() {
        runningBehavior.accept(true)
    }
}

struct ProcessOperatorEnginePresenter {
    private let engine = ProcessOperatorEngine()
    // 今回は、Boolを渡す必要がないため、mapでVoidに変換
    var startEngine: Observable<Void> { return engine.running.filter{ $0 }.map({ _ -> Void in }) }
    
    func start() {
        engine.start()
    }
}
