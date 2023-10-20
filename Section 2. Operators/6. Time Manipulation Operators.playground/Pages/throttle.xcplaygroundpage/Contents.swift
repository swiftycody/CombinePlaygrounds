import Combine
import SwiftUI
import PlaygroundSupport

let throttleDelay = 1.0

// 1. String을 방출할 Subject
let subject = PassthroughSubject<String, Never>()

// 2. latest를 false로 하여 throttled subject는
// 각 1초 간격으로 subject로부터 받은 첫번째값만 방출
let throttled = subject
    .throttle(for: .seconds(throttleDelay), 
              scheduler: DispatchQueue.main,
              latest: true)
    .share() // 3. 모든 subscriber가 throttled subject에서 동일한 값을 share받음


let subjectTimeline = TimelineView(title: "방출된 값")
let throttledTimeline = TimelineView(title: "throttle된 값")

let view = VStack(spacing: 100) {
    subjectTimeline
    throttledTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
throttled.displayEvents(in: throttledTimeline)

let subscription1 = subject
    .sink { string in
        print("+\(deltaTime)초: Subject 방출됨: \(string)")
    }

let subscription2 = throttled
    .sink { string in
        print("+\(deltaTime)초: Throttled 방출됨: \(string)")
    }

subject.feed(with: typingHelloWorld)
