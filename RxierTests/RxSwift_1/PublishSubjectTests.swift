//
//  PublishSubjectTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import XCTest
@testable import Rxier
import RxSwift

class PublishSubjectTests: XCTestCase {
	
	func testPublishSubject() {
		let hoge = PublishSubject_Hoge.init()
		let expectedIndex = 1

		// Observableのsubscribeを呼び出して、イベントを購読
		let disposable = hoge.event.subscribe(onNext: { (index) in
			XCTAssertEqual(expectedIndex, index)
		}, onError: { (error) in
			fatalError(error.localizedDescription)
		}, onCompleted: {
			print("completed")
		})
		
		hoge.next(index: expectedIndex)
		// 購読が必要なくなったら破棄
		disposable.dispose()
	}
}
