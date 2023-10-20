import Foundation
import Combine

example(of: "Type erasure") {
    var subscriptions = Set<AnyCancellable>()
    
    // 1. PassthroughSubject를 생성
    let subject = PassthroughSubject<Int, Never>()
    
    // 2. subject에서 type-erase된 publisher를 생성
    let publisher = subject.eraseToAnyPublisher()
    
    // 3. type-erase된 publisher를 subscribe
    publisher
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 4. subject를 통해 새 값을 전달
    subject.send(0)
}

