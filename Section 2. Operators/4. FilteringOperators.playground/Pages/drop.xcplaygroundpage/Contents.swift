import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "dropFirst") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. dropFirst(8)로 처음 8개의 값을 무시하고 9와 10만 출력
    numbers
        .dropFirst(8)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(while:)") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. drop(while:)을 사용하여 5로 나눌 수 있는 첫 번째 값이 나올 때까지 drop하고, 조건이 끝나는 즉시 drop이 끝나고 값을 방출시키기 시작합니다.
    numbers
        .drop(while: { $0 % 5 != 0 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(untilOutputFrom:)") {
    // 1. 수동으로 값을 전송할 수 있는 두 개의 PassthroughSubject를 생성
    // 첫 번째는 isReady. 두 번째는 사용자의 tap
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2. drop(untilOutputFrom: isReady)를 사용하여 isReady가 적어도 하나의 값을 내보낼 때까지 사용자의 tap을 무시
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3. subject로 5번의 tap을 전달.
    (1...5).forEach { n in
        taps.send(n)
        
        // 4. 세 번째 tap 후에는 isReady에 값을 전달
        if n == 3 {
            isReady.send()
        }
    }
}
