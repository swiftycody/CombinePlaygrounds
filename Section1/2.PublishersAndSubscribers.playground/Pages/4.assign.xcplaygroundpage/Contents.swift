import Foundation
import Combine

// assign(to:on:)과 함께 Subscribe하기
example(of: "assign(to:on:)") {
    // 1. didSet을 가진 클래스를 정의
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    // 2. 해당 클래스의 인스턴스 생성
    let object = SomeObject()
    
    // 3. String 배열에서 publisher를 만듦
    let publisher = ["Hello", "world!"].publisher
    
    // 4. publisher를 subscibe하여 받은 각 값을 object의 value 프로퍼티에 할당(assign)
    _ = publisher
        .assign(to: \.value, on: object)
}


// assign(to:)와 함께 Republishing
example(of: "assign(to:)") {
    // 1. @Published가 달린 프로퍼티를 가진 클래스를 정의
    // 이 프로퍼티는 보통 프로퍼티로 접근할 수 있고, 값에 대한 publisher도 생성 가능
    class SomeObject {
        @Published var value = 0
    }
    
    let object = SomeObject()
    
    // 2. @Published 프로퍼티에 $접두사를 사용하여 기본 publisher에 접근하고, subscribe하여 수신된 값을 print
    object.$value
        .sink {
            print($0)
        }
    
    // 3. Int publisher를 생성하고, object의 값 publisher에 Int publisher가 내보내는 값을 할당(assign)
    // &접두사는 프로퍼티에 대한 inout 참조를 나타내기 위해 사용
    (0..<10).publisher
        .assign(to: &object.$value)
}
