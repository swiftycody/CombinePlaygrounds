import Foundation
import Combine

example(of: "Future") {
    var subscriptions = Set<AnyCancellable>()
    
    func futureIncrement(
        integer: Int,
        afterDelay delay: TimeInterval) -> Future<Int, Never> {
            Future<Int, Never> { promise in
                print("Original") // added
                
                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    promise(.success(integer + 1))
                }
            }
        }
    
    // 1. 위 factory함수(futureIncreament)를 사용하여 3초 delay후 전달한 Int를 증가시키는 Future를 생성
    let future = futureIncrement(integer: 1, afterDelay: 3)
    
    // 2. 받은 값과 completion이벤트를 subscribe 및 print하고,
    // 생성된 subscription을 subscriptions 세트에 저장
    future
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    future // added
        .sink(
            receiveCompletion: { print("Second", $0) },
            receiveValue: { print("Second", $0) }
        )
        .store(in: &subscriptions)
    
}
