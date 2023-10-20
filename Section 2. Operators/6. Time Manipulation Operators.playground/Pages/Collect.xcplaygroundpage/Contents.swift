import Combine
import SwiftUI
import PlaygroundSupport

// 지정된 시간간격으로 Publisher로부터 값을 collect해야할 때에 필요. buffering의 형태.

let valuesPerSecond = 1.0
let collectTimeStride = 4
let collectMaxCount = 2

// 1. Timer가 방출할 값을 전달할 sourcePublisher
let sourcePublisher = PassthroughSubject<Date, Never>()

// 2. colect 연산자로 'collectTimeStride의 보폭 동안 수신하는 값을 수집하는 collectedPublisher'를 생성
// 연산자는 이러한 값 그룹을 지정된 스케줄러(DispatchQueue.main)에 배열로 방출
let collectedPublisher = sourcePublisher
    .collect(.byTime(DispatchQueue.main, .seconds(collectTimeStride)))
    .flatMap { dates in dates.publisher }

let collectedPublisher2 = sourcePublisher
    .collect(.byTimeOrCount(DispatchQueue.main,
                            .seconds(collectTimeStride),
                            collectMaxCount))
    .flatMap { dates in dates.publisher }

// Timer로 일정시간 동안 값을 방출
let subscription = Timer
    .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common)
    .autoconnect()
    .subscribe(sourcePublisher)

// 방출된 값과 collect된 값들의 방출을 보여줄 TimelineView들
let sourceTimeline = TimelineView(title: "방출된 값들:")
let collectedTimeline = TimelineView(title: "Collect된 값들 (매 \(collectTimeStride)초마다):")
let collectedTimeline2 = TimelineView(title: "Collect된 값들 (최대 \(collectMaxCount)개씩 매 \(collectTimeStride)초마다):")


let view = VStack(spacing: 40) {
    sourceTimeline
    collectedTimeline
    collectedTimeline2
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

// TimelineView들에 각 소스들 표시
sourcePublisher.displayEvents(in: sourceTimeline)
collectedPublisher.displayEvents(in: collectedTimeline)
collectedPublisher2.displayEvents(in: collectedTimeline2)

