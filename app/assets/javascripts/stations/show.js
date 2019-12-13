 $(function() {
  // 地図オブジェクト
  var map;
  // 情報ウィンドウオブジェクト
  var infowindow;
  // マーカーオブジェクを格納する変数
  var markers = [];
  // 場所検索サービスオブジェクト
  var service;

  // jqueryオブジェクトからDOM要素を取得
  map = new google.maps.Map($(".map").get(0), {
    // 地図にはじめに表示する場所・ズーム
    center: {lat: 36.397, lng: 139.644},
    zoom: 10
  });

  // ユーザが検索で指定した場所をGoogleMapで検索
  service = new google.maps.places.PlacesService(map);
  infowindow = new google.maps.InfoWindow();
  
  var request = {
    query: $(".destination").val(),
    fields: ['name', 'geometry','icon','photos','formatted_address'],
  };
  // 場所結果結果
  var result = [];

  service.findPlaceFromQuery(request, function(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      for (var i = 0; i < results.length; i++) {
        // 場所とその緯度経度を取得し配列に保存
        result.push(results[i]);
      }
      //場所の名前を表示する
      var html = results[0].name;
      $(".result__where").append(html);

      // 地図の中心を目的地に設定
      // 現在は取得結果の一番初めの場所に設定中
      map.setCenter(result[0].geometry.location);
      // ズーム
      map.setZoom(16);

      /// その場所を地図上にマーカーで表示、クリックで情報も表示
      // マーカーオブジェクトの生成
      marker = new google.maps.Marker({
        map: map,
        position: result[0].geometry.location
      })
      // マーカーをクリックしたら場所の名前を表示するよう設定
      google.maps.event.addListener(marker, 'click', function() {
        // 場所の名前と住所
        infowindow.setContent(result[0].name + result[0].formatted_address);
          // 場所の種類を表すアイコンinfowindow.setContent(place.icon);
          // 写真？infowindow.setContent(place.photos.html_attributions);
          // 写真のURLを取得console.log(place.photos[0].html_attributions);
        infowindow.open(map, this);
      });
      markers.push(marker);

      /// その場所から最も近い駅を検索する
      // 緯度経度それぞれ±0.1度(約10km)の範囲の駅を取得
      //ajaxを使う
      $.ajax({
        url: "/stations/search",
        type: "get", //ルーティングより
        dataType: "json",
        data: { lat: result[0].geometry.location.lat(),lng: result[0].geometry.location.lng()}
      })
        // 現在地から近い順に最大3駅のデータが返ってくる
        .done(function(stations) {
          // 付近の駅が1つ以上取得できたら最寄駅の駅チャット画面にリンクするhtmlタグを作成し、
          // result__stationクラスのdivタグに追加する
          if(stations[0].name != null){
            stations.forEach(function(station, index){
              if(station.name != null){
              var html = `<div class="station__info">
                            <div class="station__info__number">${index+1}番目に近い駅</div>
                              <div><a class="station__info__name" href="/stations/${station.id}/messages">${station.name}駅</a></div>
                                <div class="station__info__length">(目的地から${station.dist}m) <br></div></div>`;
              $(".result__station").append(html);
              /// 検索した駅にマーカーを立てる
              // マーカーオブジェクトの生成
              //marker = new google.maps.Marker({
                //map: map,
                //position: {lat: station.lat, lng: station.lng},
                //label: {
                  //text: `${station.name}駅はここ`,                           //ラベル文字
                  //color: '#0000ff',                    //文字の色
                  //fontSize: `${16-index}px`                     //文字のサイズ
                //}
              //})
              // マーカーをクリックしたら場所の名前を表示するよう設定
              google.maps.event.addListener(marker, 'click', function() {
                // 場所の名前と住所
                infowindow.setContent(station.name);
                infowindow.open(map, this);
              });
              markers.push(marker);
            }
          })
        }else{
          // 駅が存在しない場合には、行き先のみを地図に表示し、駅名には「検索可能な駅が付近に存在しません」のメッセージを表示する
          var html = `<p>検索可能な駅が付近に存在しません</p>`;
          $(".result__station").append(html);
        }
      })
      .fail(function() {
        alert("最寄駅の取得に失敗しました...");
      });
    }
  });
});