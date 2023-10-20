import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "removeDuplicates") {
    // 1. 문장을 단어 배열(예: [문자열])로 분리한 다음 이 단어들을 방출할 새 Publisher를 생성
    let words = "hey hey there! want to listen to mister mister ?"
        .components(separatedBy: " ")
        .publisher
    // 2. words Publisher에 removeDuplicates()를 적용
    words
        .removeDuplicates()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}
