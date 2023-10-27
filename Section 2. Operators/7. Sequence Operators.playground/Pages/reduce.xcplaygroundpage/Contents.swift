import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "reduce") {
    // 1. 문자열을 방출하는 publisher
    let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
    
    publisher
        .print("publisher")
        .reduce("") { accumulator, value in
            // 2. reduce()로 기존 누적값과 방출된 값을 붙임
            accumulator + value
        }
        .sink(receiveValue: { print("Reduced into: \($0)") })
        .store(in: &subscriptions)
}
