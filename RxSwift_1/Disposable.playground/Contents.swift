//: Playground - noun: a place where people can play

import UIKit
import RxSwift

/**
* MyViewController が解放されるときに disposeBag も解放され、管理下にある全ての Disposable の dispose が呼び出されます
*/
struct Hoge {
	private let eventSubject = PublishSubject<Int>()
	var event: Observable<Int> { return eventSubject }

	var event1: Observable<Int> { return eventSubject }

	var event2: Observable<Int> { return eventSubject }
}

class MyViewController: UIViewController {
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let hoge = Hoge()
		
		hoge.event.subscribe(onNext: { index in
			
		}).disposed(by: disposeBag)
		
		hoge.event1.subscribe(onNext: { index in
			
		}).disposed(by: disposeBag)

		hoge.event2.subscribe(onNext: { index in
			
		}).disposed(by: disposeBag)
	}
}
