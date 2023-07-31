import UIKit

/*
아래는 Apple 공식문서의 설명을 번역했습니다.
(https://developer.apple.com/documentation/combine)
 
 Customize handling of asynchronous events by combining event-processing operators.
 이벤트 처리 operator를 결합하여, 비동기 이벤트 처리를 Customize 하는 Framework.
 
 Combine framework는 시간 경과에 따른 값 처리를 위한 선언적 Swift API를 제공합니다.
 이 값들은 많은 종류의 비동기 이벤트들을 나타낼 수 있습니다.
 Combine은 publisher가 시간이 지남에 따라 변경될 수 있는 값을 노출하고, subscriber가 publisher로부터 이러한 값들을 받을 수 있도록 선언합니다.
 
 - Publisher 프로토콜은 시간 경과에 따라 시퀀스 값들을 전달받을 수 있는 타입을 선언합니다. Publisher는 upstream Publisher로부터 받은 값에 따라 작업하고 다시 publish 할 수 있는 Operator를 가지고 있습니다.
 - Publisher의 체인 끝에, Subscriber는 element를 받을 때 해당 element에 대한 작업을 수행합니다. Publisher는 Subscriber가 명시적으로 request 한 경우에만 값을 내보냅니다. 이렇게 하면 Subscriber 코드가 연결된 Publisher로부터 이벤트를 받는 속도를 제어할 수 있습니다.
 
 Timer, NotificationCenter, URLSession을 포함한 여러 Foundation Type이 Publisher를 통해 기능을 보여줍니다.
 그리고 Combine은 Key-Value Observing을 준수하는 모든 Property에 대해 기본 제공 Publisher를 제공합니다.
 
 여러 Publisher의 출력을 결합(combine)하고 상호작용을 조정할 수 있습니다.
 예를 들어 텍스트필드의 Publisher에서 업데이트를 subscribe 하고 텍스트를 사용하여 URL요청을 할 수 있습니다.
 그리고 다른 Publisher를 사용하여 응답을 처리하고 앱을 업데이트하는 데 사용할 수 있습니다.
 
 Combine을 채택하면, 이벤트 처리 코드를 중앙 집중화하고 중첩된 클로저 및 컨벤션기반 콜백과 같은 번거로운 기술을 제거하여 코드를 읽고 유지보수하기 쉽게 만들 수 있습니다.
 
*/
