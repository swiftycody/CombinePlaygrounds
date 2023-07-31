import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "filter") {
    // 1.시퀀스 타입에서 publisher 프로퍼티을 사용하여 1부터 10까지 한정된 수의 값을 방출하는 새 publisher를 생성
    let numbers = (1...10).publisher
    
    // 2. filter operator를 사용하여 3의 배수인 숫자만 통과하도록 허용하는 클로저를 전달
    numbers
        .filter { $0.isMultiple(of: 3) }
        .sink(receiveValue: { n in
            print("\(n) is a multiple of 3!")
        })
        .store(in: &subscriptions)
}

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


example(of: "ignoreOutput") {
    // 1. 1부터 10,000까지 10,000개의 값을 출력하는 publisher를 생성
    let numbers = (1...10_000).publisher
    
    // 2. 모든 값을 생략하고 completed 이벤트만 consumer에게 전송하는 ignoreOutput를 추가
    numbers
        .ignoreOutput()
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "first(where:)") {
    // 1. 1부터 9까지의 Int를 방출하는 새 publisher를 생성
    let numbers = (1...9).publisher
    
    // 2. first(where:) operator를 사용하여 첫 번째로 방출된 짝수 값을 탐색
    numbers
        .print("numbers") // 3. lazy한 동작을 확인하기 위한 print
        .first(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "last(where:)") {
    // 1. 1에서 9 사이의 Int를 방출하는 Publisher 생성
    let numbers = (1...9).publisher
    
    // 2. last(where:) operator로 마지막으로 방출된 짝수 값을 탐색
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "last(where:)") {
    let numbers = PassthroughSubject<Int, Never>()
    
    numbers
        .last(where: { $0 % 2 == 0 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    numbers.send(1)
    numbers.send(2)
    numbers.send(3)
    numbers.send(4)
    numbers.send(5)
    numbers.send(completion: .finished)
}

example(of: "dropFirst") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. dropFirst(8)로 처음 8개의 값을 무시하고 9와 10만 출력
    numbers
        .dropFirst(8)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(while:)") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. drop(while:)을 사용하여 5로 나눌 수 있는 첫 번째 값이 나올 때까지 drop하고, 조건이 끝나는 즉시 drop이 끝나고 값을 방출시키기 시작합니다.
    numbers
        .drop(while: { $0 % 5 != 0 })
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "drop(untilOutputFrom:)") {
    // 1. 수동으로 값을 전송할 수 있는 두 개의 PassthroughSubject를 생성
    // 첫 번째는 isReady. 두 번째는 사용자의 tap
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2. drop(untilOutputFrom: isReady)를 사용하여 isReady가 적어도 하나의 값을 내보낼 때까지 사용자의 tap을 무시
    taps
        .drop(untilOutputFrom: isReady)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
    
    // 3. subject로 5번의 tap을 전달.
    (1...5).forEach { n in
        taps.send(n)
        
        // 4. 세 번째 tap 후에는 isReady에 값을 전달
        if n == 3 {
            isReady.send()
        }
    }
}

example(of: "prefix") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. prefix(2)를 사용하여 처음 두 값만 방출하도록 함. 두 개의 값이 방출되는 즉시 publisher가 completed
    numbers
        .prefix(2)
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "prefix(while:)") {
    // 1. 1에서 10 사이의 Int를 방출하는 publisher 생성
    let numbers = (1...10).publisher
    
    // 2. prefix(while:)를 사용하여 값이 3보다 작으면 통과시킵니다. 3보다 크거나 같은 값이 나오면 퍼블리셔가 완료
    numbers
        .prefix(while: { $0 < 3 })
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
}

example(of: "prefix(untilOutputFrom:)") {
    // 1. 수동으로 값을 전송할 수 있는 두 개의 PassthroughSubject를 생성
    // 첫 번째는 isReady. 두 번째는 사용자의 tap
    let isReady = PassthroughSubject<Void, Never>()
    let taps = PassthroughSubject<Int, Never>()
    
    // 2. prefix(untilOutputFrom: isReady)를 사용하여 isReady가 값을 내보낼 때까지 tap 이벤트를 통과
    taps
        .prefix(untilOutputFrom: isReady)
        .sink(
            receiveCompletion: { print("Completed with: \($0)") },
            receiveValue: { print($0) }
        )
        .store(in: &subscriptions)
    
    // 3. Subject을 통해 5번의 tap을 보내고
    (1...5).forEach { n in
        taps.send(n)
        
        // 4. 두 번째 탭 후에는 isReady에 값을 보냄
        if n == 2 {
            isReady.send()
        }
    }
}




