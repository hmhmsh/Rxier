//
//  DisposableTests.swift
//  RxierTests
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import UIKit
import XCTest
import RxSwift

class DisposableTests: XCTestCase {
    
    func testDisposable() {
        var myVC: MyViewController? = MyViewController()
        myVC = nil
    }
}

/**
 * MyViewController が解放されるときに disposeBag も解放され、管理下にある全ての Disposable の dispose が呼び出されます
 */
struct DisposableHoge {
    private let eventSubject = PublishSubject<Int>()
    var event: Observable<Int> { return eventSubject }
    
    var event1: Observable<Int> { return eventSubject }
    
    var event2: Observable<Int> { return eventSubject }
}

class MyViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hoge = DisposableHoge()
        
        hoge.event.subscribe(onNext: { index in
            
        }).disposed(by: disposeBag)
        
        hoge.event1.subscribe(onNext: { index in
            
        }).disposed(by: disposeBag)
        
        hoge.event2.subscribe(onNext: { index in
            
        }).disposed(by: disposeBag)
    }
}
