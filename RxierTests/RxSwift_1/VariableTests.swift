//
//  VariableTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import XCTest
import RxSwift

class VariableTests: XCTestCase {
    
    func testVariable() {
        let presenter = VariablePresenter()
        var expectedHidden = false
        
        let disposable = presenter.buttonHidden.subscribe(onNext: { (hidden) in
            XCTAssertEqual(expectedHidden, hidden)
        }, onCompleted: {
            print("comp")
        })
        
        expectedHidden = true
        presenter.start()
        expectedHidden = false
        presenter.pause()
        presenter.stop()
        disposable.dispose()
        
        XCTAssertEqual(expectedHidden, presenter.getValue())
    }
}
