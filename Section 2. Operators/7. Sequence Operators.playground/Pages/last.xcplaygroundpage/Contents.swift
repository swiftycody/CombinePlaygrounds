import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "last") {
    // 1. 3개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C"].publisher
    
    // 2. complete을 기다렸다가 마지막값만 print
    publisher
        .print("publisher")
        .last()
        .sink(receiveValue: { print("마지막 값은 \($0)") })
        .store(in: &subscriptions)
}
