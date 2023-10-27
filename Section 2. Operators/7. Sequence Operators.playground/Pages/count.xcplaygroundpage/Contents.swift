import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "count") {
    // 1. 3개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C"].publisher
    
    // 2. count()로 upstream publisher가 방출한 값의 갯수를 출력
    publisher
        .print("publisher")
        .count()
        .sink(receiveValue: { print("\($0)개의 아이템을 받음") })
        .store(in: &subscriptions)
}
