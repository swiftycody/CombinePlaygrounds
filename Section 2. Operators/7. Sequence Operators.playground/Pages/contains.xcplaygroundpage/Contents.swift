import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "contains") {
    // 1. 5개의 글자를 방출하는 Publisher
    let publisher = ["A", "B", "C", "D", "E"].publisher
    let letter = "C"
    
    // 2. contains()를 사용해서 upstream publishe가 letter를 보냈는지를 체크
    publisher
        .print("publisher")
        .contains(letter)
        .sink(receiveValue: { contains in
            // 3. letter가 포함되면 print
            print(contains ? "Publisher가 '\(letter)'를 방출함"
                  : "Publisher가 '\(letter)'를 방출 안함")
        })
        .store(in: &subscriptions)
}

example(of: "contains(where:)") {
    // 1. id, name을 포함한 Almond struct
    struct Almond {
        let id: Int
        let name: String
    }
    
    // 2.3개의 Almond를 방출하는 publisher
    let almonds = [(123, "Honey butter"),
                  (777, "Wasabi"),
                  (214, "Mint choco")]
        .map(Almond.init)
        .publisher
    
    // 3. contains(where:)로 아몬드 id가 214인지 체크
    almonds
        .contains(where: { $0.id == 214 })
        .sink(receiveValue: { contains in
            // 4
            print(contains ? "민초 노노!"
                  : "민초만 아니면 되!")
        })
        .store(in: &subscriptions)
}
