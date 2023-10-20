import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "filter") {
    // 1.시퀀스 타입에서 publisher 프로퍼티을 사용하여 1부터 10까지 한정된 수의 값을 방출하는 새 publisher를 생성
    let numbers = (1...10).publisher
    
    // 2. filter operator를 사용하여 3의 배수인 숫자만 통과하도록 허용하는 클로저를 전달
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3!")
        })
        .store(in: &subscriptions)
}
