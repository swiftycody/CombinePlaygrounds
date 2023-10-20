import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

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
