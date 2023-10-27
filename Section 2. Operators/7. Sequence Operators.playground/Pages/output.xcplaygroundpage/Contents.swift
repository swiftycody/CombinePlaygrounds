import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "output(at:)") {
    // 1. 3개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C"].publisher
    
    // 2. output(at:)으로 upstream publisher의 index 1의 방출만 통과시키고, cancel시킴
    publisher
        .print("publisher")
        .output(at: 1)
        .sink(receiveValue: { print("index 1의 값: \($0)") })
        .store(in: &subscriptions)
}

example(of: "output(in:)") {
    // 1. 5개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C", "D", "E"].publisher
    
    // 2. output(in:)으로 upstream publisher의 index 1...3의 방출만 통과시키고, cancel시킴
    publisher
        .output(in: 1...3)
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print("범위내의 값: \($0)") }
        )
        .store(in: &subscriptions)
}
