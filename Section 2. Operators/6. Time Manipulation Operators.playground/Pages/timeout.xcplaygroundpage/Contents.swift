import Combine
import SwiftUI
import PlaygroundSupport

enum TimeoutError: Error {
    case timedOut
}

let subject = PassthroughSubject<Void, TimeoutError>()

// 1. upstream publisher가 5초간 아무값을 방출하지 않으면 시간 초과가 됩니다.
let timedOutSubject = subject.timeout(.seconds(5),
                                      scheduler: DispatchQueue.main,
                                      customError: { .timedOut })

let timeline = TimelineView(title: "Button 탭")

let view = VStack(spacing: 100) {
    // 1. 버튼을 누르면 subject 방출
    Button(action: { subject.send() }) {
        Text("5초 내로 버튼 탭")
    }
    timeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

timedOutSubject.displayEvents(in: timeline)
