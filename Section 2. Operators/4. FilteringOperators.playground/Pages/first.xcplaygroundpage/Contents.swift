import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "first(where:)") {
    // 1. 1부터 9까지의 Int를 방출하는 새 publisher를 생성
    let numbers = (1...9).publisher
    
    // 2. first(where:) operator를 사용하여 첫 번째로 방출된 짝수 값을 탐색
    numbers
        .print("numbers") // 3. lazy한 동작을 확인하기 위한 print
        .first(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}
