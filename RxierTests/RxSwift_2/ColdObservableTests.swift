//
//  ColdObservableTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/29.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

/*
 * Observable.create は Cold な Observable を作る汎用的な方法です。「subscribe されるとサーバーからデータを取得する処理を開始する」Observable を作って返しています。
 */
class ColdObservableTests: XCTestCase {
    
    var disposable: Disposable?
    
    func testColdObservable() {
        let expectation = XCTestExpectation(description: "wait for data task")

        let coldObservable = ColdServerDataStore()
        guard let url = URL(string: "https://apple.com") else {
            fatalError()
        }
        
        disposable = coldObservable.fetch(url: url).subscribe(onNext: { (data) in
            print("onNext: \(data)")
        }, onError: { (error) in
            print("onError: \(error)")
            XCTAssert(true)
            self.disposable?.dispose()
            expectation.fulfill()
        }, onCompleted: {
            print("onCompleted")
            XCTAssert(true)
            self.disposable?.dispose()
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}

struct ColdServerDataStore {
    func fetch(url: URL) -> Observable<Data> {
        return Observable.create({ (observer) -> Disposable in
            let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? FetchServerDataError.NoData)
                }
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
