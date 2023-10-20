import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "zip") {
    // (1) 2개의 다른 타입의 publisher 생성
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // (2) 2개의 publisher를 zip으로 묶음
    publisher1
        .zip(publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print("P1: \($0), P2: \($1)") }
        )
        .store(in: &subscriptions)
    
    // (3) 1과 2를 publisher1에서 방출
    publisher1.send(1)
    publisher1.send(2)
    // "a"와 "b"를 publisher2에서 방출
    publisher2.send("a")
    publisher2.send("b")
    // 3을 다시 publisher1에서 방출
    publisher1.send(3)
    // "c"와 "d"를 publisher2에서 방출
    publisher2.send("c")
    publisher2.send("d")
    
    // (4) 두 publisher를 모두 completion
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
