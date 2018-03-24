//
//  BindToTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import XCTest
import RxSwift

class BindToTests: XCTestCase {
    
    func testBindTo() {
        let button = UIButton()
        let presenter = BindToPresenter()
        
        var expectedHidden = false
        
        /**
         * subscribe pattern
         */
        let disposable = presenter.buttonHidden.subscribe(onNext: { (hidden) in
            button.isHidden = hidden
            XCTAssertEqual(expectedHidden, button.isHidden)
        })
        
        /**
         * bindTo pattern
         */
        let disposable2 = presenter.buttonHidden.bind(to: button.rx.isHidden)
        
        expectedHidden = true
        presenter.start()
        expectedHidden = false
        presenter.pause()
        disposable.dispose()
        disposable2.dispose()
    }
    
    func testBindToSelf() {
        var expectedHidden = false
        
        let hoge = BindToHoge(onNext: { (hidden) in
            XCTAssertEqual(expectedHidden, hidden)
            })
        let presenter = BindToPresenter()
        let disposable3 = presenter.buttonHidden.bind(to: hoge.isHidden)
        
        expectedHidden = true
        presenter.start()
        expectedHidden = false
        presenter.pause()
        disposable3.dispose()
    }
}
