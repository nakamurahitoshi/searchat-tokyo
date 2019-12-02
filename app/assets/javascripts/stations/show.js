 $(function() {
  // 地図オブジェクト
  var map;
  // マーカーオブジェクト
  var marker;
  // 場所検索サービスオブジェクト
  var service;

  // jqueryオブジェクトからDOM要素を取得
  map = new google.maps.Map($(".map").get(0), {
    // 地図にはじめに表示する場所・ズーム
    center: {lat: 35.397, lng: 139.644},
    zoom: 8
  });

  // ユーザが指定した場所をGoogleMapで検索
  service = google.maps.places.PlacesService
  // その場所の緯度経度を取得

  // その場所の緯度経度とズームを地図に設定し、マーカーに表示
  // マーカー設置
  marker = new google.maps.Marker({
    position: lat_lng,
    map: map
  });

  // その場所から最も近い駅を検索する

    // 緯度経度それぞれ±0.1度(約10km)の範囲の駅を取得

    // その場所と駅との距離を、緯度経度により計算

    // 最も距離が近い駅をマーカーに表示





// 地図クリック時のイベントを定義
function getClickLatLng(lat_lng, map) {
  //すでに定義されているマーカーがあれば削除
  if ( marker ) {
    marker.setMap(null);
  }
  // 座標を取得
  var lat = lat_lng.lat();
  var lng = lat_lng.lng();
  
  // マーカー設置
  marker = new google.maps.Marker({
    position: lat_lng,
    map: map
  });
  // 座標の中心をずらす
  map.panTo(lat_lng);
  $(".lat").text(`緯度は${lat}です。`)
  $(".lng").text(`経度は${lng}です。`)
  }
});