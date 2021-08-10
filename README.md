

# 목차
- 프로젝트 소개
- 개발환경 및 라이브러리
- 실행화면
- 구현 기능
- 기능 구현을 위한 고민, 새로 알게된 것
- 부족한 부분

<br>

---

<br>

# GoTogeDog

산책친구를 만들어보자!
심심한 산책길, 나와 함께 산책할 내 주변의 애견인들을 찾아 매칭시켜주는 앱 입니다.

<br>

---

<br>

## 개발환경 및 라이브러리
- Kakao SDK
- [lottie-ios](https://github.com/airbnb/lottie-ios)
- Firebase
- NMapsMap
- [PanModal](https://github.com/slackhq/PanModal)
- [YPImagePicker](https://github.com/Yummypets/YPImagePicker)
- [Kingfisher](https://github.com/onevcat/Kingfisher) - **`6.0`**

<br>

---

<br>

## 실행 화면

<br>

> ### 프로필 설정화면, 채팅방 화면

<p><img src="https://user-images.githubusercontent.com/55231029/120976091-f6920880-c7ac-11eb-9a75-43ddfe582045.PNG" width="250" height="500">
<img src="https://user-images.githubusercontent.com/55231029/120976181-0d385f80-c7ad-11eb-9b11-bb698cfa5d05.PNG" width="250" height="500"></p>

<br>
<br>

> ### 반려견 프로필설정

![이미지 5](https://user-images.githubusercontent.com/55231029/120975970-d5311c80-c7ac-11eb-9031-7cadbbd3eccc.GIF)

<br>
<br>

> ### 산책위치 설정 화면

![이미지 4](https://user-images.githubusercontent.com/55231029/120975317-0c52fe00-c7ac-11eb-9ea3-601644376d94.GIF)

<br>
<br>

> ### 내 주변 친구찾기

![이미지 2](https://user-images.githubusercontent.com/55231029/120974069-a9149c00-c7aa-11eb-9b07-de6005b0c454.GIF)

<br>
<br>

> ### 상세 프로필

![이미지 3](https://user-images.githubusercontent.com/55231029/120974378-03adf800-c7ab-11eb-9650-9295785a21bc.GIF)




<br>

---

<br>

## 구현 기능

### 1. 내 정보 설정
- 산책 위치 확인, 수정하기
- 멍멍이 프로필 정보 확인, 수정하기
- 멍멍이 사진 확인, 수정하기
- 주인님 프로필 정보 확인, 수정하기
- 주인님 사진 확인, 수정하기


### 2. 내 주변 친구찾기
- 기준 주소기반 주변 산책친구 리스트 목록 확인
- 상세화면
- 함께산책하기 신청


### 3. 메이트 알람 확인 페이지
- 알람 리스트 확인
- 상세화면
- 신청 수락 or 거절

### 4. 채팅목록
- 채팅 리스트 확인
    
### 5. 채팅방
- 메세지 송수신


<br>

---

<br>

## 기능 구현을 위한 고민, 새로 알게된 것
    
### 1. 산책 위치 설정하기


<p><img src="https://user-images.githubusercontent.com/55231029/128679034-b9cbae8b-38d6-47f9-82d3-6886f46ab484.png" width="250" height="500">
<img src="https://user-images.githubusercontent.com/55231029/120975317-0c52fe00-c7ac-11eb-9ea3-601644376d94.GIF" width="250" height="500">
</p>

산책 위치는 위와 같이 지도 가운데의 손가락 모양이 가리키고 있는 좌표값을 이용해 Kakao Api 에서 해당 지역의 주소를 받아오게 됩니다. 
이 기능을 구현하기 위해서 맵을 드래그 할 때마다 api 를 호출하여 손가락이 가리키는 위치의 주소를 받아왔었는데, 

이때 두가지 문제가 발생했습니다.

1. 드래그 할 때마다 api 호출이 너무 많이 일어나게 되고

2. 빠른 속도로 맵을 움직이게 된다면 api 호출에 대한 Response의 순서가 뒤바뀌게 되어 잘못된 주소를 이용자의 화면에 노출시키게 되는 문제였습니다.

위의 문제들은 맵을 드래그 할 때마다 api 호출을 하는 방식때문이었습니다.

문제들을 해결하기 위해서 `NMapsMap` 의 문서를 통해 `NMFMapViewCameraDelegate` 의 메소드를 override 해서 드래그 이벤트가 끝나는 시점에 api 를 호출하여 api 호출 횟수를 최소화 하는 방식으로 문제를 해결했습니다.

- `NMFMapViewCameraDelegate` 의 드래그 이벤트가 종료되는 시점에 호출되는 메소드 

```swift
 func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
	let coord = mapView.projection.latlng(from: walkPoint.center)
        let param = RegioncodeParam(x: "\(coord.lng)", y: "\(coord.lat)")
        
        KakaoAPIManager().requestRegioncode(param: param) { response in
            self.walkLocationViewModel.setWalkLocation(walkLocation: response.documents.first!)
            DispatchQueue.main.async {
                self.addressLabel.text = response.documents.first?.address_name
            }
        }
}
```


<br>

---

<br>

### 2. 채팅방 인터페이스 구현
<p><img src="https://user-images.githubusercontent.com/55231029/128682263-1c6cec98-dc30-4db1-ad7e-09f03fd31dfb.png" width="250" height="500">
</p>

이 프로젝트에서 구현하기 가장 어려웠던 인터페이스가 채팅방 이었습니다.
크게 3가지로 나눠 보자면,

1. 메세지 내용에 따른 말풍선의 크기 
2. 메세지 송신 혹은 수신 할 때에 TableView에 cell을 추가하는 방식
3. 메세지 송신 혹은 수신 할 때에 TableView의 scroll 위치 변경

**`1번`** 

말풍선으로 표현될 TableViewCell 을 xib파일로 만들고, 오토레이아웃을 적용해서 구현했습니다. 이 과정에서 `Resistance Priority` 와 `Stretching` 에 대한 개념을 공부하고, 직접 적용해볼 수 있었습니다.

**`2번`** 

메세지가 추가되어 `TableView` 에 `Cell` 이 추가될 때, `tableView.reloadData()` 를 사용했었습니다. 하지만 reloadData 를 할 경우 메세지 양이 많을 때에 **새로고침되는 중** 에 **화면 깜빡임이 발생** 했습니다. 이에 대해 찾아보니 `tableView` 의 **전체 cell** 을 `reload` 하기 때문에 화면 깜빡임이 발생한다는 걸 알게 되었고, **cell 전체** 를 **`reload`** 하기보다 tableView의 **마지막 인덱스 위치에 cell 하나를 추가** 하는 **`insertRows`** 를 이용하여 화면 깜빡임 문제를 해결했습니다.

- **tableView cell들의 맨 뒤에 cell 추가**

```swift
// IndexPath 찾기
let lastIndexPath = IndexPath(row: chatRoomViewModel.messages.count - 1, section: 0)
// cell 추가
tableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.automatic)
```


**`3번`**

`TableViewCell` 의 개수가 **화면에 표시할 수 있는** `cell` 의 개수보다 많아지게 되면 **추가되는 `cell`** 이 화면에 표시되지 않는 경우가 있었습니다. 

이 문제를 해결하기 위해서 cell이 마지막 인덱스 위치에 추가될 경우, **scroll의 위치를 가장 마지막 셀의 인덱스 위치로 이동** 시켜주었습니다.

- **scroll의 위치 변환**

```swift
// 마지막 셀의 IndexPath를 찾기
let lastIndexPath = IndexPath(row: chatRoomViewModel.messages.count - 1, section: 0)
//scroll 이동
tableView.scrollToRow(at: lastIndexPath, at: UITableView.ScrollPosition.bottom
                              , animated: true)

```

<br>

---

<br>

## 부족한 부분

기능 구현에만 집중하다보니 앱 실행중 예외처리에 대한 부분을 하나도 신경쓰지 못했습니다.
때문에 로그인한 `유저의 정보` 같은 중요한 정보들을 `Optional 변수` 에 **저장** 하도록 했는데, `유저 정보` 를 불러오지 못할 경우 아예 **앱 실행이 중지되는 문제**와 같은 치명적인 문제들이 자주 발생하게 되었습니다.

고투개독은 iOS 프레임워크에 대한 기본적인 지식도 많이 부족한 상태로 시작하여 공부하면서 진행한 프로젝트 였습니다. `화면 전환` , `ViewController 간의 데이터 교환` , `AutoLayout` , `인터페이스 구현`  부분에 있어서도 프로젝트 **초반** 과 **후반** 의 `코드 작성 규칙` 이 달라져 **코드의 일관성** 도 무너지게 되었습니다.

아쉬운 부분이 많았지만 앞으로 앱 개발시에 `예외처리에 대한 부분` , **화면간의 데이터 교환** 을 위한 `Delegation` , `Notification` , `AutoLayout`  등과 같이 앞으로 어떤걸 공부해야할지 감을 잡을 수 있었던 프로젝트였습니다.
