import Foundation

/*
 Apple에서는 UIKit/Appkit에서 다양한 방식의 비동기식 프로그래밍을 할 수 있는 메커니즘을 만들어왔습니다.
 NotificationCenter, Delegate Pattern, GCD, Closure, Timer 등..
 
 Combine은 비동기 코드를 설계하고 작성하기 위해 Swift 생태계에 공통의 언어를 도입합니다.
 Apple은 Combine을 기존의 Timer, CoreData, NotificationCenter와 같은 핵심프레임워크에도 Combine을 사용할 수 있게 만들었습니다.
 Foundation부터 SwiftUI까지 Combine으로 통합할 수 있도록 만들었습니다.
 
 */

/*
 // Combine Basics
 
 Combine의 핵심요소는 Publishers, Operators, Subscribers.
 다른 요소들도 있지만 위 세가지는 필수입니다.
 
 * Publisher
 : 하나 이상의 Subscriber에게 시간이 지남에 따라 값을 내보낼 수 있는 타입입니다.
 수학 연산, 네트워킹, User event 처리를 포함한 거의 대부분의 Publisher의 내부 로직과 관계없이 3가지 타입의 이벤트를 내보낼 수 있습니다.
 
 - Publisher의 Generic타입의 'Output'
 - Success 완료
 - Publisher의 Failure타입의 error가 있는 완료
 
 Publisher는 0개 이상의 Output값을 내보낼 수 있고, 성공 혹은 실패로 완료된 경우 다른 이벤트를 내보낼 수 없습니다.
 
 
 */
