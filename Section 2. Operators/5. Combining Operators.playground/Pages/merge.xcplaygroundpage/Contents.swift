import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "merge(with:)") {
    // (1) Int 값을 방출하고 Error가 없는 두 개의 PassthroughSubject
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // (2) publisher1을 publisher2와 merge하여 두 publisher 모두에서 방출한 값을 interleave시킴(최대 8명의 다른 게시자를 병합 가능)
    publisher1
        .merge(with: publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    // (3) publisher1에 1과 2를 추가하고
    publisher1.send(1)
    publisher1.send(2)
    
    // publisher2에 3을 추가한 다음
    publisher2.send(3)
    
    // 다시 publisher1에 4를 추가하고
    publisher1.send(4)
    
    // 마지막으로 publisher2에 5를 추가
    publisher2.send(5)
    
    // (4) publisher1과 publisher2 모두에게 completion 이벤트
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
