import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "max") {
    // 1. 4개의 글자를 방출하는 Publisher
    let publisher = ["A", "F", "Z", "E"].publisher
    
    // 2. max 연산자로 최대값을 찾아서 pring
    publisher
        .print("publisher")
        .max()
        .sink(receiveValue: { print("최대값은 \($0)") })
        .store(in: &subscriptions)
}
