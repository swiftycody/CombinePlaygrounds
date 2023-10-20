import Combine
import SwiftUI
import PlaygroundSupport

// 1. String을 방출할 subject
let subject = PassthroughSubject<String, Never>()

// 2. debounce로 1초간 기다렸다가 값을 전달.
// 1초 간격으로 전달된 마지막 값이 있는 경우 해당값을 방출. 초당 1번만 방출하게 됨.
let debounced = subject
    .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
    .share() // 3. debounce된 Publisher를 여러번 subscribe하더라도 일관된 값을 받도록 하기 위해 share 연산자 사용.


let subjectTimeline = TimelineView(title: "값 방출")
let debouncedTimeline = TimelineView(title: "Debounce된 값")

let view = VStack(spacing: 100) {
    subjectTimeline
    debouncedTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
debounced.displayEvents(in: debouncedTimeline)

let subscription1 = subject
    .sink { string in
        print("+\(deltaTime)초: Subject 방출됨: \(string)")
    }

let subscription2 = debounced
    .sink { string in
        print("+\(deltaTime)초: Debounce후 방출됨: \(string)")
    }

subject.feed(with: typingHelloWorld)
