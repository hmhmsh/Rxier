//
//  HotObservable.swift
//  RxierTests
//
//  Created by hmhm on 2018/03/26.
//  Copyright © 2018 hmhmsh. All rights reserved.
//

import Foundation
import XCTest
import RxSwift

/*
* Subject を使ったものが Hot な Observable です。Subject そのものでなくても、例えば Variable のように内部で Subject を使っているものもあります。
* どこからも subsusribe されていなくても動作する
* 複数から subscribe されると同じ動作結果を通知する
*/

/*
* HotなObservableを使って非同期通信結果を通知してみる
*/
class HotObservableTests: XCTestCase {
	
	var disposable: Disposable?
	
	func testHotObservable() {
		let dataStore = ServerDataStore()
		disposable = dataStore.resultEvent.subscribe(onNext: { (data) in
			XCTAssert(true)
			print("onNext: \(data)")
			self.dispose()
		}, onError: { (error) in
			XCTAssert(false)
			print("onError: \(error)")
			self.dispose()
		})
		dataStore.resume(url: URL(fileURLWithPath: ""))
	}
	
	func dispose() {
		disposable?.dispose()
	}
	
}

enum FetchServerDataError: Error {
	case NoData
}

class ServerDataStore {
	private let resultSubject = PublishSubject<Data>()
	var resultEvent: Observable<Data> { return resultSubject }
	
	private var task: URLSessionDataTask?
	
	func resume(url: URL) {
		task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { [resultSubject] (data, response, error) in
			
			DispatchQueue.main.async {
				guard let data = data else {
					resultSubject.onError(error ?? FetchServerDataError.NoData)
					return
				}
				resultSubject.onNext(data)
				resultSubject.onCompleted()
			}
			
		}
		
		task?.resume()
	}
	
	func cancel() {
		task?.cancel()
	}
	
}
