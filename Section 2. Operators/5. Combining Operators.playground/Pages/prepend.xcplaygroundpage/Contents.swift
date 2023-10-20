import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prepend(Output...)") {
    // 1. 숫자 3 4를 방출하는 Publisher를 생성
    let publisher = [3, 4].publisher
    
    // 2. prepend를 사용하여 Publisher의 자체 값 앞에 숫자 1과 2를 추가
    publisher
        .prepend(1, 2)
        .prepend(-1, 0)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Sequence...)") {
    // 1. 숫자 3 4를 방출하는 Publisher를 생성
    let publisher = [3, 4].publisher
    
    publisher
        .prepend(1, 2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Sequence)") {
    // 1. 숫자 5, 6, 7을 방출하는 Publisher를 생성
    let publisher = [5, 6, 7].publisher
    
    // 2. prepend(Sequence)를 원래 publisher에게 두 번 추가
    // 한 번은 Array의 값을 앞에 추가하고 두 번째는 Set의 값을 앞에 추가
    publisher
        .prepend([3, 4])
        .prepend(Set(1...2))
        .prepend(stride(from: 6, to: 11, by: 2))
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Publisher)") {
    // 1. 숫자 3과 4를 방출하는 publisher와 1과 2를 방출하는 publisher를 생성
    let publisher1 = [3, 4].publisher
    let publisher2 = [1, 2].publisher
    
    // 2. Publisher1의 시작 부분에 Publisher2를 추가.
    // Publisher1은 작업 수행을 시작하고 Publisher2가 finished completion 이벤트를 보낸 후에만 이벤트를 방출.
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Publisher) #2") {
    // 1. 첫 번째 publisher는 값 3과 4를 방출.
    // 두 번째 publisher는 값을 동적으로 받아들일 수 있는 PassthroughSubject
    let publisher1 = [3, 4].publisher
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // 2. Publisher1 앞에 subject를 prepend
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3. subject로 값 1과 2를 방출
    publisher2.send(1)
    publisher2.send(2)
    publisher2.send(completion: .finished)
    
}
