import Foundation
import Combine

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
