import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "allSatisfy") {
    // 1. 0~5사이 2씩 증가시키며 방출시키는 publisher
    let publisher = stride(from: 0, to: 5, by: 2).publisher
    
    // 2. allSatisfy()로 모든 방출된 값이 짝수인지 체크
    publisher
        .print("publisher")
        .allSatisfy { $0 % 2 == 0 }
        .sink(receiveValue: { allEven in
            print(allEven ? "모든 값이 짝수!"
                  : "어떤 값은 홀수!")
        })
        .store(in: &subscriptions)
}
