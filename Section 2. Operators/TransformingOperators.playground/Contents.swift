import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
    ["A", "B", "C", "D", "E"].publisher
        .collect(2) // 2개씩 묶도록 지정
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "map") {
    // 1. 각 숫자의 spell을 입력할 formatter를 생성
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    // 2. Int Publisher를 생성
    [123, 4, 56].publisher
    // 3. map(_:)으로 'Upstream 값을 가져와 formatter로 문자열로 변환한 값을 반환하는 클로저'를 전달
        .map {
            formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "mapping key paths") {
    // 1. Coordinate, Never 타입의 PassthroughSubject를 생성
    let publisher = PassthroughSubject<Coordinate, Never>()
    
    // 2. publisher의 subscription 생성
    publisher
        .map(\.x, \.y) // 3. 키패스로 Coordinate의 x, y 프로퍼티에 매핑
        .sink(receiveValue: { x, y in
            print( // 4. map으로부터 전달받은 x, y를 처리
                "The coordinate at (\(x), \(y)) is in quadrant",
                quadrantOf(x: x, y: y)
            )
        })
        .store(in: &subscriptions)
    
    // 5. subject를 통해 Coordinate들을 전달
    publisher.send(Coordinate(x: 10, y: -8))
    publisher.send(Coordinate(x: 0, y: 5))
}

example(of: "tryMap") {
    // 1. 존재하지 않는 디렉터리명을 내보내는 Just
    Just("DirectoryNameNotExist")
        .tryMap { // 2. 해당 디렉터리 내용을 가져오기 위해 try
            try FileManager.default.contentsOfDirectory(atPath: $0)
        }
        .sink(receiveCompletion: { print("completion: \($0)") }, // 3. 이벤트를 수신
              receiveValue: { print("value: \($0)") })
        .store(in: &subscriptions)
}

example(of: "flatMap") {
    // 1. 각 ASCII 코드를 나타내는 Int배열을 받아서,
    // Error를 내보내지 않는 String 타입의 Type-erase된 Publisher를 반환하는 함수
    func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
        // 2. 32~255범위의 code를 받아서 ASCII 문자를 반환하는 Just
        Just(
            codes
                .compactMap { code in
                    guard (32...255).contains(code) else { return nil }
                    return String(UnicodeScalar(code) ?? " ")
                }
                .joined() // 3. 문자열로 Join
        )
        .eraseToAnyPublisher() // 4. AnyPublisher로 반환하기 위한 type-erase
    }
    
    // 5.ASCII 문자 배열을 Publisher로 변환
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
        .publisher
        .collect()
        .flatMap(decode) // 6. flatMap으로 배열 요소들을 단일 배열로 모아서 decode(_:)로 전달
        .sink(receiveValue: { print($0) }) // 7. decode(_:)로 반환된 Publisher를 sink
        .store(in: &subscriptions)
}

example(of: "replaceNil") {
    // 1. [String?] 을 Publisher로 만듦
    ["A", nil, "C"].publisher
        .eraseToAnyPublisher()
        .replaceNil(with: "-") // 2. nil 값을 -로 변환
        .sink(receiveValue: { print($0) }) // 3. sink로 subscribe
        .store(in: &subscriptions)
}

example(of: "replaceEmpty(with:)") {
    // 1. complete을 바로 내보내는 Empty Publisher
    let empty = Empty<Int, Never>()
    
    // 2. subscribe
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "scan") {
//    // 1.
//    var dailyGainLoss: Int { .random(in: -10...10) }
//
//    // 2
//    let august2019 = (0..<22)
//        .map { _ in dailyGainLoss }
//        .publisher
//
//    // 3
//    august2019
//        .scan(50) { latest, current in
//            max(0, latest + current)
//        }
//        .sink(receiveValue: { print($0) })
//        .store(in: &subscriptions)

}
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher
    .scan(0) { $0 + $1 }
    .sink(receiveValue: { print($0) })
.store(in: &subscriptions)
