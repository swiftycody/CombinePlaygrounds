import Foundation
import Combine

// Publisher의 예제
// 기존 NotificationCenter에서 notification을 publish할 수 있는 Publisher타입을 제공
example(of: "Publisher") {
    // 1. 알림 이름을 만듦
    let myNotification = Notification.Name("MyNotification")
    
    // 2. NotificationCenter의 default 인스턴스에 액세스하고 publisher(for:object:)메서드를 호출하고 반환 값을 로컬 상수에 할당
    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)
    
    // 3. default notificationCenter에 대한 핸들을 가져옴
    let center = NotificationCenter.default
    
    // 4. 위에서 만든 이름으로 notification을 수신한 observer를 만듦
    let observer = center.addObserver(
        forName: myNotification,
        object: nil,
        queue: nil) { notification in
            print("Notification received!")
        }
    
    // 5. 해당 이름으로 notification을 post
    center.post(name: myNotification, object: nil)
    
    // 6. notificationCenter에서 observer를 제거
    center.removeObserver(observer)
}

// sink(_:_:)와 함께 Subscribe하기
example(of: "Subscriber") {
    let myNotification = Notification.Name("MyNotification")
    let center = NotificationCenter.default
    
    let publisher = center.publisher(for: myNotification, object: nil)
    
    // 1. publisher의 sink를 호출하여 Subscription을 만듦
    let subscription = publisher
        .sink { _ in
            print("Notification received from a publisher!")
        }
    
    // 2. notification을 post
    center.post(name: myNotification, object: nil)
    
    // 3. subscription을 취소
    subscription.cancel()

}

// 단일 값을 방출하는 Just
// sink operator는 publisher가 방출하는 만큼의 값을 계속 받게 됨
//example(of: "Just") {
// 1. 단일 값으로 publisher를 생성할 수 있는 Just를 이용하여 publisher를 생성
let just = Just("Hello world!")

// 2. publisher에 대한 subscription을 만들고, 받은 각각의 이벤트에 대한 메세지를 print
_ = just
    .sink(
        receiveCompletion: {
            print("Received completion", $0)
        },
        receiveValue: {
            print("Received value", $0)
        })

_ = just
    .sink(
        receiveCompletion: {
            print("Received completion (another)", $0)
        },
        receiveValue: {
            print("Received value (another)", $0)
        })
//}

// assign(to:on:)과 함께 Subscribe하기
example(of: "assign(to:on:)") {
    // 1. didSet을 가진 클래스를 정의
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    // 2. 해당 클래스의 인스턴스 생성
    let object = SomeObject()
    
    // 3. String 배열에서 publisher를 만듦
    let publisher = ["Hello", "world!"].publisher
    
    // 4. publisher를 subscibe하여 받은 각 값을 object의 value 프로퍼티에 할당(assign)
    _ = publisher
        .assign(to: \.value, on: object)
}


// assign(to:)와 함께 Republishing
example(of: "assign(to:)") {
    // 1. @Published가 달린 프로퍼티를 가진 클래스를 정의
    // 이 프로퍼티는 보통 프로퍼티로 접근할 수 있고, 값에 대한 publisher도 생성 가능
    class SomeObject {
        @Published var value = 0
    }
    
    let object = SomeObject()
    
    // 2. @Published 프로퍼티에 $접두사를 사용하여 기본 publisher에 접근하고, subscribe하여 수신된 값을 print
    object.$value
        .sink {
            print($0)
        }
    
    // 3. Int publisher를 생성하고, object의 값 publisher에 Int publisher가 내보내는 값을 할당(assign)
    // &접두사는 프로퍼티에 대한 inout 참조를 나타내기 위해 사용
    (0..<10).publisher
        .assign(to: &object.$value)
}

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


//example(of: "Future") {
//    var subscriptions = Set<AnyCancellable>()

//    func futureIncrement(
//        integer: Int,
//        afterDelay delay: TimeInterval) -> Future<Int, Never> {
//            Future<Int, Never> { promise in
//                print("Original") // added
//
//                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
//                    promise(.success(integer + 1))
//                }
//            }
//        }
//
//    // 1. 위 factory함수(futureIncreament)를 사용하여 3초 delay후 전달한 Int를 증가시키는 Future를 생성
//    let future = futureIncrement(integer: 1, afterDelay: 3)
//
//    // 2. 받은 값과 completion이벤트를 subscribe 및 print하고,
//    // 생성된 subscription을 subscriptions 세트에 저장
//    future
//        .sink(
//            receiveCompletion: { print($0) },
//            receiveValue: { print($0) }
//        )
//        .store(in: &subscriptions)
//
//    future // added
//        .sink(
//            receiveCompletion: { print("Second", $0) },
//            receiveValue: { print("Second", $0) }
//        )
//        .store(in: &subscriptions)
//
//}


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
    
    
//    subject.send(completion: .failure(MyError.test)) // (추가)
    
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

