import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prefix") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. prefix(2)를 사용하여 처음 두 값만 방출하도록 함. 두 개의 값이 방출되는 즉시 publisher가 completed
    numbers
        .prefix(2)
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "prefix(while:)") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. prefix(while:)를 사용하여 값이 3보다 작으면 통과시킵니다. 3보다 크거나 같은 값이 나오면 퍼블리셔가 완료
    numbers
        .prefix(while: { $0 < 3 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "prefix(untilOutputFrom:)") {
    // 1. 수동으로 값을 전송할 수 있는 두 개의 PassthroughSubject를 생성
    // 첫 번째는 isReady. 두 번째는 사용자의 tap
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2. prefix(untilOutputFrom: isReady)를 사용하여 isReady가 값을 내보낼 때까지 tap 이벤트를 통과
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    // 3. Subject을 통해 5번의 tap을 보내고
    (1...5).forEach { n in
        taps.send(n)
        
        // 4. 두 번째 탭 후에는 isReady에 값을 보냄
        if n == 2 {
            isReady.send()
        }
    }
}
