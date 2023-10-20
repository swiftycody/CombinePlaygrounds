import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "compactMap") {
    // 1. 문자열 목록을 방출하는 퍼블리셔를 생성합니다.
    let strings = ["a", "1.24", "3",
                   "def", "45", "0.23"].publisher
    
    // 2. compactMap을 사용하여 각 String에서 Float를 초기화하려고 시도.
    // Float의 이니셜라이저가 제공된 String을 변환할 수 없는 경우 nil을 반환.
    // 이러한 nil 값은 compactMap 연산자에 의해 자동으로 필터링.
    strings
        .compactMap { Float($0) }
        .sink(receiveValue: {
            // 3. Float로 성공적으로 변환된 String만 출력
            print($0)
        })
        .store(in: &subscriptions)
}
