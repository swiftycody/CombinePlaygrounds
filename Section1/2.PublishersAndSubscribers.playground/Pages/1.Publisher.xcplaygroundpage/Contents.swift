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

