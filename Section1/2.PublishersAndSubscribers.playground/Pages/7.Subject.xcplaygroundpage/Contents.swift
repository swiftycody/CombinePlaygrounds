import Foundation
import Combine

example(of: "PassthroughSubject") {
    // 1. Error 타입을 정의
    enum MyError: Error {
        case test
    }
    
    // 2. String, MyError를 받는 Custom Subscriber를 정의
    final class StringSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            // 3. 받은 값을 기준으로 demand를 조절함
            return input == "World" ? .max(1) : .none
        }
        
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    
    // 4. Custom Subscriber의 인스턴스를 생성
    let subscriber = StringSubscriber()
    
    // 5. String과 MyError가 정의된 타입의 PassthroughSubject인스턴스를 생성
    let subject = PassthroughSubject<String, MyError>()
    
    // 6. subscriber를 subject에 subscribe등록
    subject.subscribe(subscriber)
    
    // 7. sink로 또다른 subscription을 생성
    let subscription = subject
        .sink(
            receiveCompletion: { completion in
                print("Received completion (sink)", completion)
            },
            receiveValue: { value in
                print("Received value (sink)", value)
            }
        )
    
    subject.send("Hello")
    subject.send("World")
    
    // 8. 두번째 구독을 cancel
    subscription.cancel()
    
    // 9. 새로운 값을 내보냄
    subject.send("Still there?")
    
    
    // subject.send(completion: .failure(MyError.test)) // (추가)
    
    subject.send(completion: .finished)
    subject.send("How about another one?")
}

example(of: "CurrentValueSubject") {
    // 1. subscription을 저장할 Set 생성
    var subscriptions = Set<AnyCancellable>()
    
    // 2. Int, Never 타입의 CurrentValueSubject 생성. 초기값은 0
    let subject = CurrentValueSubject<Int, Never>(0)
    
    // 3. subscription 생성. subject에게 값을 받아 print
    subject
        .print("[1st subscription]")
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions) // 4. cancellables에 store
    
    subject.send(1)
    subject.send(2)
    
    print("value: ", subject.value)
    
    subject.value = 3
    print("value: ", subject.value)
    
    subject
        .print("[2nd subscription]")
        .sink(receiveValue: { print("2nd subscription:", $0) })
        .store(in: &subscriptions)
    
    subject.send(completion: .finished)
}
