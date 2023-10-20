import Foundation
import Combine

// Custom Subscriber
example(of: "Custom Subscriber") {
    // 1. range의 publisher 프로퍼티를 통해 Int의 Publisher를 생성
    let publisher = [0, 1, -1, -2, 2, -3, 3, -4, 4].publisher
    //    let publisher = ["A", "B", "C", "D", "E", "F"].publisher
    
    
    // 2. Custom Subscriber로 IntSubscriber 정의
    final class IntSubscriber: Subscriber {
        // 3. typealias를 구현하여 이 subscriber가 Int입력을 받을 수 있으며, Error을 받지 않도록 지정
        typealias Input = Int
        typealias Failure = Never
        
        // 4. publisher로부터 호출된 receive(subscription:)으로 시작하여 필요한 메서드를 구현
        // 이 메서드에서 subscriber가 subscribe시 최대 3개의 값을 수신할 것을 지정하는 subscription의 .request(_:)를 호출
        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }
        
        // 5. 받은 input을 print. subscriber가 Demand를 조정하지 않음을 나타내는 .none을 반환.
        // .none은 .max(0)과 같음
        // .unlimited는 .max(1)과 같음
        func receive(_ input: Int) -> Subscribers.Demand {
            if input < 0 {
                return .max(1)
            }
            else {
                print("Received value", input)
                return .none
            }
        }
        
        // 6. completion 이벤트를 print
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    
    // publisher가 어떤것을 publish하려면 subscriber가 필요
    let subscriber = IntSubscriber()
    
    publisher.subscribe(subscriber)
}
