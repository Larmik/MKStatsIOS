//
//  InstantObservable.swift
//  Stats MK
//
//  Created by Pascal Alberti on 21/01/2024.
//

import Foundation
import RxSwift

open class InstantObservables<T> {
    lazy var disposeBag = DisposeBag()

    public init() { }

    lazy var observables: [Observable<T>] = []
    lazy var disposables: [Disposable] = []

    func enqueue(observable: Observable<T>) {
        let shared = observable.share(replay: 1)
        observables.append(shared)

        let disposable = shared
            .subscribe()

        disposables.append(disposable)

        disposable
            .disposed(by: disposeBag)
    }

    open func removeAndStop(atIndex index: Int) {
        guard observables.indices.contains(index)
            && disposables.indices.contains(index) else {
            return
        }
        let disposable = disposables.remove(at: index)
        disposable.dispose()

        _ = observables.remove(at: index)
    }

    func waitForAllObservablesToBeFinished() -> Observable<[T]> {
        let multipleObservable = Observable.zip(observables)
        observables.removeAll()
        disposables.removeAll()
        return multipleObservable
    }

    open func cancelObservables() {
        disposeBag = DisposeBag()
    }
}
