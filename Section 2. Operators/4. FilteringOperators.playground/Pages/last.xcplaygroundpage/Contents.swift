import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "last(where:)") {
    // 1. 1에서 9 사이의 Int를 방출하는 Publisher 생성
    let numbers = (1...9).publisher
    
    // 2. last(where:) operator로 마지막으로 방출된 짝수 값을 탐색
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "last(where:)") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    numbers.send(completion: .finished)
}
