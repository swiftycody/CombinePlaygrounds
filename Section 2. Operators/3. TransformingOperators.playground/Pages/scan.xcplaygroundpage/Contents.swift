import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "scan") {
    //    // 1.
    //    var dailyGainLoss: Int { .random(in: -10...10) }
    //
    //    // 2
    //    let august2019 = (0..<22)
    //        .map { _ in dailyGainLoss }
    //        .publisher
    //
    //    // 3
    //    august2019
    //        .scan(50) { latest, current in
    //            max(0, latest + current)
    //        }
    //        .sink(receiveValue: { print($0) })
    //        .store(in: &subscriptions)
    
}

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher
    .scan(0) { $0 + $1 }
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)

