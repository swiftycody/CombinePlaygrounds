import Combine
import SwiftUI
import PlaygroundSupport

var subscriptions = Set<AnyCancellable>()

let valuesPerSecond = 1.0
let delayInSeconds = 1.5

// 1. sourcePublisher는 타이머가 내보내는 날짜를 공급할 Subject
let sourcePublisher = PassthroughSubject<Date, Never>()

// 2. delayedPublisher는 sourcePublisher에서 값을 delay시켜 main scheduler에서 값을 방출
let delayedPublisher = sourcePublisher.delay(for: .seconds(delayInSeconds),
                                             scheduler: DispatchQueue.main)

// 3. main thread에서 초당 하나의 값을 전달하는 타이머를 만듦
// autoconnect()를 사용해서 즉시 시작하고 sourcePublisher를 통해 방출되는 값을 제공
let subscription = Timer
    .publish(every: 1.0 / valuesPerSecond,
             on: .main,
             in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

    
// 4.Timer의 값을 표시할 TimelineView 생성
let sourceTimeline = TimelineView(title: "방출된 값 (\(valuesPerSecond)초마다 방출):")

// 5. Delay된 Value를 표시할 TimelineView 생성
let delayedTimeline = TimelineView(title: "Delay된 값들 (\(delayInSeconds)초 delay):")

// 6. 위 두 TimelineView를 VStack으로
let view = VStack(spacing: 50) {
    sourceTimeline
    delayedTimeline
}

// 7. PlaygroundPage에 liveView 설정
PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

//sourcePublisher.displayEvents(in: sourceTimeline)
//delayedPublisher.displayEvents(in: delayedTimeline)
