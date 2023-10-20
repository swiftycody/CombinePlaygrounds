import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "append(Output...)") {
    // 1. 단일값 1을 내보내는 publisher
    let publisher = [1].publisher
    
    // 2. 2, 3을 append하고 4를 append
    publisher
        .append(2, 3)
        .append(4)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "append(Output...) #2") {
    // 1. publisher는 수동으로 값을 보낼 수 있는 PassthroughSubject로
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .append(3, 4)
        .append(5)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 2. PassthroughSubject에 1과 2를 방출
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
    
}

example(of: "append(Sequence)") {
    // (1) 1, 2, 3을 방출하는 publisher 생성
    let publisher = [1, 2, 3].publisher
    
    publisher
        .append([4, 5]) // (2) 4와 5(순서대로)를 사용하여 배열을 추가
        .append(Set([6, 7])) // (3) 6과 7(순서 없음)을 사용하여 Set를 추가
        .append(stride(from: 8, to: 11, by: 2)) // (4) 8에서 11 사이를 2씩 증가하는 Strideable을 추가
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "append(Publisher)") {
    // (1) 첫 번째 publisher는 1과 2를 방출
    // 두 번째 publisher는 3과 4를 방출
    let publisher1 = [1, 2].publisher
    let publisher2 = [3, 4].publisher
    
    // (2) publisher2를 publisher1에 appen
    // publisher2의 모든 값이 완료되면 publisher1의 끝에 추가
    publisher1
        .append(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
