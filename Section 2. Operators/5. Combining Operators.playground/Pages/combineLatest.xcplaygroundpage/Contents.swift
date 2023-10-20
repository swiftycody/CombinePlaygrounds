import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "combineLatest") {
    // (1) 2개의 다른 타입의 publisher 생성
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // (2) Publisher2의 최신 방출값을 Publisher1과 결합.
    // (CombineLatest의 여러 오버로드를 사용하여 최대 4개의 게시자를 결합 가능)
    publisher1
        .combineLatest(publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print("P1: \($0), P2: \($1)") }
        )
        .store(in: &subscriptions)
    
    // (3) 1과 2를 publisher1에 방출하고
    publisher1.send(1)
    publisher1.send(2)
    
    // "a"와 "b"를 publisher2로 방출
    publisher2.send("a")
    publisher2.send("b")
    
    // 3을 publisher1로 방출
    publisher1.send(3)
    
    // "c"를 publisher2로 방출
    publisher2.send("c")
    
    // (4) 두 publisher 모두 completion
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
