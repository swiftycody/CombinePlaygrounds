import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "min") {
    // 1. 숫자를 방출하는 Publisher
    let publisher = [1, -50, 246, 0].publisher
    
    // 2. min 연산자로 최소값을 찾아서 print
    publisher
        .print("publisher")
        .min()
        .sink(receiveValue: { print("최소값은 \($0)") })
        .store(in: &subscriptions)
}

example(of: "min non-Comparable") {
    // 1. 문자열 배열로 생성한 Publisher<Data, Never>
    let publisher = ["12345",
                     "ab",
                     "hello world"]
        .map { Data($0.utf8) } // [Data]
        .publisher // Publisher<Data, Never>
    
    // 2. min(by:) 연산자로 byte수가 가장 작은 data를 찾은 뒤 string으로 print
    publisher
        .print("publisher")
        .min(by: { $0.count < $1.count })
        .sink(receiveValue: { data in
            // 3
            let string = String(data: data, encoding: .utf8)!
            print("최소값은 \(string), \(data.count) bytes")
        })
        .store(in: &subscriptions)
}
