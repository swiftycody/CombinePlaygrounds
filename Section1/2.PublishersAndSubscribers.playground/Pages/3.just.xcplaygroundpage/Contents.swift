import Foundation
import Combine

// 단일 값을 방출하는 Just
// sink operator는 publisher가 방출하는 만큼의 값을 계속 받게 됨
example(of: "Just") {
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
}
