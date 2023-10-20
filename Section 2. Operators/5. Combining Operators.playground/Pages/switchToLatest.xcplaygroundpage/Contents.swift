import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()


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
