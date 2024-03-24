//
//  Observable+MKStats.swift
//  Stats MK
//
//  Created by Pascal Alberti on 18/01/2024.
//

import Foundation
import RxSwift
import RxCocoa

typealias Observable = RxSwift.Observable

extension ObservableType {

    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */

    public func unWrap<Result>() -> RxSwift.Observable<Result> where Element == Result? {
        return self.compactMap { $0 }
    }

}

