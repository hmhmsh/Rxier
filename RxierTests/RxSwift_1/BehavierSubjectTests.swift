//
//  BehavierSubject.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import XCTest
import RxSwift

class BehavierSubjectTests: XCTestCase {
	
	func testBehavierSubject() {
		let presenter = BehavierSubjectPresenter()
		var expectHidden = false
		let disposable = presenter.buttonHidden.subscribe(onNext: { (hidden) in
			XCTAssertEqual(expectHidden, hidden)
		}, onCompleted: {
			print("comp")
		})
		
		expectHidden = true
		presenter.start()
		expectHidden = false
		presenter.pause()
		presenter.stop()
		disposable.dispose()
		
		XCTAssertEqual(expectHidden, presenter.getValue())
	}
}
