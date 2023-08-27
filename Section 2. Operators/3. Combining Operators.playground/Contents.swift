import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prepend(Output...)") {
    // 1. 숫자 3 4를 방출하는 Publisher를 생성
    let publisher = [3, 4].publisher
    
    // 2. prepend를 사용하여 Publisher의 자체 값 앞에 숫자 1과 2를 추가
    publisher
        .prepend(1, 2)
        .prepend(-1, 0)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Sequence...)") {
    // 1. 숫자 3 4를 방출하는 Publisher를 생성
    let publisher = [3, 4].publisher
    
    publisher
        .prepend(1, 2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Sequence)") {
    // 1. 숫자 5, 6, 7을 방출하는 Publisher를 생성
    let publisher = [5, 6, 7].publisher
    
    // 2. prepend(Sequence)를 원래 publisher에게 두 번 추가
    // 한 번은 Array의 값을 앞에 추가하고 두 번째는 Set의 값을 앞에 추가
    publisher
        .prepend([3, 4])
        .prepend(Set(1...2))
        .prepend(stride(from: 6, to: 11, by: 2))
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Publisher)") {
    // 1. 숫자 3과 4를 방출하는 publisher와 1과 2를 방출하는 publisher를 생성
    let publisher1 = [3, 4].publisher
    let publisher2 = [1, 2].publisher
    
    // 2. Publisher1의 시작 부분에 Publisher2를 추가.
    // Publisher1은 작업 수행을 시작하고 Publisher2가 finished completion 이벤트를 보낸 후에만 이벤트를 방출.
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "prepend(Publisher) #2") {
    // 1. 첫 번째 publisher는 값 3과 4를 방출.
    // 두 번째 publisher는 값을 동적으로 받아들일 수 있는 PassthroughSubject
    let publisher1 = [3, 4].publisher
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // 2. Publisher1 앞에 subject를 prepend
    publisher1
        .prepend(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3. subject로 값 1과 2를 방출
    publisher2.send(1)
    publisher2.send(2)
    publisher2.send(completion: .finished)

}

example(of: "append(Output...)") {
    // 1. 단일값 1을 내보내는 publisher
    let publisher = [1].publisher
    
    // 2. 2, 3을 append하고 4를 append
    publisher
        .append(2, 3)
        .append(4)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "append(Output...) #2") {
    // 1. publisher는 수동으로 값을 보낼 수 있는 PassthroughSubject로
    let publisher = PassthroughSubject<Int, Never>()
    
    publisher
        .append(3, 4)
        .append(5)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 2. PassthroughSubject에 1과 2를 방출
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)

}

example(of: "append(Sequence)") {
    // (1) 1, 2, 3을 방출하는 publisher 생성
    let publisher = [1, 2, 3].publisher
    
    publisher
        .append([4, 5]) // (2) 4와 5(순서대로)를 사용하여 배열을 추가
        .append(Set([6, 7])) // (3) 6과 7(순서 없음)을 사용하여 Set를 추가
        .append(stride(from: 8, to: 11, by: 2)) // (4) 8에서 11 사이를 2씩 증가하는 Strideable을 추가
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "append(Publisher)") {
    // (1) 첫 번째 publisher는 1과 2를 방출
    // 두 번째 publisher는 3과 4를 방출
    let publisher1 = [1, 2].publisher
    let publisher2 = [3, 4].publisher
    
    // (2) publisher2를 publisher1에 appen
    // publisher2의 모든 값이 완료되면 publisher1의 끝에 추가
    publisher1
        .append(publisher2)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "switchToLatest") {
    // (1) Int를 방출하고, Error가 없는 3개의 publisher 생성
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    let publisher3 = PassthroughSubject<Int, Never>()
    
    // (2) 다른 PassthroughSubject를 방출하는 두 번째 PassthroughSubject를 생성
    // publisher1, publisher2, publisher3를 방출시킬 수 있음.
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    
    // (3) 게시자에서 switchToLatest를 사용.
    // publishers를 통해 다른 publisher를 보낼 때마다 새 publisher로 전환하고 이전 subscription을 취소.
    publishers
        .switchToLatest()
        .sink(
            receiveCompletion: { _ in print("Completed!") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    // (4) publisher1을 publishers에게 보낸 다음 1과 2를 publisher1에게 방출
    publishers.send(publisher1)
    publisher1.send(1)
    publisher1.send(2)
    
    // (5) publisher1에 대한 subscription을 취소하는 publisher2를 보냄.
    // 그리고 publisher1에게 3을 방출시키지만 무시되고
    // publisher2에 대한 활성화된 subscription이 있기 때문에 publisher2에서 4와 5를 방출
    publishers.send(publisher2)
    publisher1.send(3)
    publisher2.send(4)
    publisher2.send(5)
    
    // (6) publisher2에게 subscription을 취소하는 publisher3을 보냄.
    // 6을 Publisher2에 보내면 무시됨.
    // 그런 다음 7, 8, 9를 보내면 Publisher3에 대한 subscription을 통해 방출
    publishers.send(publisher3)
    publisher2.send(6)
    publisher3.send(7)
    publisher3.send(8)
    publisher3.send(9)
    
    // (7) 현재 Publisher(Publisher3)에게 completion 이벤트를 보내고
    // publishers에게 또 다른 completion 이벤트를 보냄 -> 이로써 모든 활성화된 subscription이 완료
    publisher3.send(completion: .finished)
    publishers.send(completion: .finished)
}

example(of: "switchToLatest - Network Request") {
//    let url = URL(string: "https://source.unsplash.com/random")!
//
//    // (1) Unsplash의 공개 API에서 임의의 이미지를 가져오기 위해 네트워크 요청을 수행하는 함수 getImage()를 정의
//    func getImage() -> AnyPublisher<UIImage?, Never> {
//        URLSession.shared
//            .dataTaskPublisher(for: url)
//            .map { data, _ in UIImage(data: data) }
//            .print("image")
//            .replaceError(with: nil)
//            .eraseToAnyPublisher()
//    }
//
//    // (2) PassthroughSubject를 생성하여 사용자가 버튼을 탭하는 것을 대체
//    let taps = PassthroughSubject<Void, Never>()
//
//    // (3) 버튼을 탭하면 getImage()를 호출하여 탭을 임의의 이미지에 대한 새 네트워크 요청에 매핑
//    // -> Publisher<Void, Never> 를 Publisher<Publisher<UIImage?, Never>, Never>로 매핑
//    taps
//        .map { _ in getImage() }
//        .switchToLatest() // (4) Publisher의 Publisher 형태로 매핑되어 switchToLatest() 사용 가능.
//        .sink(receiveValue: { _ in })
//        .store(in: &subscriptions)
//
//    // (5) DispatchQueue를 사용하여 세 번의 지연된 버튼 탭을 재현
//    taps.send()
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//        taps.send()
//    }
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
//        taps.send()
//    }
}

example(of: "merge(with:)") {
    // (1) Int 값을 방출하고 Error가 없는 두 개의 PassthroughSubject
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    // (2) publisher1을 publisher2와 merge하여 두 publisher 모두에서 방출한 값을 interleave시킴(최대 8명의 다른 게시자를 병합 가능)
    publisher1
        .merge(with: publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    // (3) publisher1에 1과 2를 추가하고
    publisher1.send(1)
    publisher1.send(2)
    
    // publisher2에 3을 추가한 다음
    publisher2.send(3)
    
    // 다시 publisher1에 4를 추가하고
    publisher1.send(4)
    
    // 마지막으로 publisher2에 5를 추가
    publisher2.send(5)
    
    // (4) publisher1과 publisher2 모두에게 completion 이벤트
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}

example(of: "combineLatest") {
    // (1) 2개의 다른 타입의 publisher 생성
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // (2) Publisher2의 최신 방출값을 Publisher1과 결합.
    // (CombineLatest의 여러 오버로드를 사용하여 최대 4개의 게시자를 결합 가능)
    publisher1
        .combineLatest(publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print("P1: \($0), P2: \($1)") }
        )
        .store(in: &subscriptions)
    
    // (3) 1과 2를 publisher1에 방출하고
    publisher1.send(1)
    publisher1.send(2)
    
    // "a"와 "b"를 publisher2로 방출
    publisher2.send("a")
    publisher2.send("b")
    
    // 3을 publisher1로 방출
    publisher1.send(3)
    
    // "c"를 publisher2로 방출
    publisher2.send("c")
    
    // (4) 두 publisher 모두 completion
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}

example(of: "zip") {
    // (1) 2개의 다른 타입의 publisher 생성
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<String, Never>()
    
    // (2) 2개의 publisher를 zip으로 묶음
    publisher1
        .zip(publisher2)
        .sink(
            receiveCompletion: { _ in print("Completed") },
            receiveValue: { print("P1: \($0), P2: \($1)") }
        )
        .store(in: &subscriptions)
    
    // (3) 1과 2를 publisher1에서 방출
    publisher1.send(1)
    publisher1.send(2)
    // "a"와 "b"를 publisher2에서 방출
    publisher2.send("a")
    publisher2.send("b")
    // 3을 다시 publisher1에서 방출
    publisher1.send(3)
    // "c"와 "d"를 publisher2에서 방출
    publisher2.send("c")
    publisher2.send("d")
    
    // (4) 두 publisher를 모두 completion
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}




