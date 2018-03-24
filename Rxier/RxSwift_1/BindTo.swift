//
//  BindTo.swift
//  Rxier
//
//  Created by 長谷川瞬哉 on 2018/03/24.
//  Copyright © 2018年 hmhmsh. All rights reserved.
//

import Foundation
import RxSwift

import RxCocoa

/**
 * Subject や Variable は Observable の bindTo メソッドの引数として渡せます。
 * この bindTo を使うと subscribe を使うより少し簡単にイベントをプロパティに接続できます。
 */
struct BindToPresenter {
    private let buttonHiddenRelay = BehaviorRelay(value: false)
    var buttonHidden: Observable<Bool> { return buttonHiddenRelay.asObservable() }
    
    func start() {
        buttonHiddenRelay.accept(true)
    }
    
    func pause() {
        buttonHiddenRelay.accept(false)
    }
}

/**
 * 自分で作成したプロパティにbindToで接続する
 */
struct BindToHoge {
    var isHidden = BehaviorRelay(value: false)
    
    init(onNext: @escaping (Bool) -> Void) {
        _ = self.isHidden.subscribe(onNext: { (hidden) in
            onNext(hidden)
        })
    }
}
