import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "ignoreOutput") {
    // 1. 1부터 10,000까지 10,000개의 값을 출력하는 publisher를 생성
    let numbers = (1...10_000).publisher
    
    // 2. 모든 값을 생략하고 completed 이벤트만 consumer에게 전송하는 ignoreOutput를 추가
    numbers
        .ignoreOutput()
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}
