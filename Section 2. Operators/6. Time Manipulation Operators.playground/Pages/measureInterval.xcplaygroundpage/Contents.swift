import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()

// 1. subject를 main 큐에서 값을 방출하게 하고, 측정하도록 지정
let measureSubject = subject.measureInterval(using: DispatchQueue.main)
let measureSubject2 = subject.measureInterval(using: RunLoop.main)

let subjectTimeline = TimelineView(title: "방출된 값")
let measureTimeline = TimelineView(title: "측정된 값")

let view = VStack(spacing: 100) {
    subjectTimeline
    measureTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
measureSubject.displayEvents(in: measureTimeline)

// subject와 measure 발출된 값 print
let subscription1 = subject.sink {
    print("+\(deltaTime)초: Subject 방출됨: \($0)")
}
let subscription2 = measureSubject.sink {
    print("+\(deltaTime)초: Measure 방출됨: \(Double($0.magnitude) / 1_000_000_000.0)")
}
let subscription3 = measureSubject2.sink {
    print("+\(deltaTime)s: Measure2 방출: \($0)")
}


subject.feed(with: typingHelloWorld)
