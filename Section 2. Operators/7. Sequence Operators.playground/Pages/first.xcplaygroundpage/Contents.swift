import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "first") {
    // 1. 3개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C"].publisher
    
    // 2. first연산자로 첫번째 값을 통과시키고 cancel
    publisher
        .print("publisher")
        .first()
        .sink(receiveValue: { print("첫번째 값은 \($0)") })
        .store(in: &subscriptions)
}

example(of: "first(where:)") {
    // 1. 4개의 글자를 방출하는 Publisher
    let publisher = ["J", "O", "H", "N"].publisher
    
    // 2. first(where:)연산자로 Hello World에 포함된 첫번째 글자를 찾고 print
    publisher
        .print("publisher")
        .first(where: { "Hello World".contains($0) })
        .sink(receiveValue: { print("첫번째 일치값은 \($0)") })
        .store(in: &subscriptions)
}
