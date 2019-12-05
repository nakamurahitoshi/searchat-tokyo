/// 駅名をインクリメンタルサーチ(非同期通信)する機能のJavascript ///
$(function() {
  // 駅入力フォームのオートコンプリート機能をoffにする
  $(".station-textfield__textfield").attr("autocomplete", "off");


  // 駅一覧がクリックされたら駅名がフォームに入力され、<form>タグの"action"がその駅のidになるようにする
  function addClickEventListener() {
    $(".station-list__station").on("click" ,function(){
      // 駅idを取得
      var station_id = $(this).data("station-id");
      // 駅名を取得
      var station_name = $(this).children("p").text();
      // テキストフォームに駅名を入れる
      $(".station-textfield__textfield").val(station_name);
      // テキストフォームのactionタグに駅idを入れる
      $(".station-input-form").attr("action", `/stations/${station_id}/messages`);
      // 検索結果一覧を削除
      $(".station-list").empty();
    });
  }

  //駅名候補一覧を加える処理
  function addStationToList(station) {
    var html = `
      <div class="station-list__station" data-station-id="${station.id}">
        <p>${station.name}</p>
      </div>
    `;
    $(".station-list").append(html);
  }

  //ユーザが発見できず空白文字が送られてきたときに行う処理
  function addNoStation() {
    let html = `
      <div class="station-list__station">
        <p>該当する駅はありません</p>
      </div>
    `;
    $(".station-list").append(html);
  }

  // テキストフォームに文字が入力されるたびに非同期通信を実行
  $(".station-textfield__textfield").on("keyup" ,function(event){
    var keycode = (event.keyCode ? event.keyCode : event.which);
    // backspaceキーまたはenterキーが押されたらアクションを実行する
    if(keycode == "8" || keycode == "13"){
      // フォームに入力された値を取得
      var input = $(".station-textfield__textfield").val();
      // 非同期通信を開始
      $.ajax({
        url: "/stations",
        type: "GET",
        data: { station_name_input: input }, //ハッシュ形式でデータを渡す
        dataType: "json"
      })  
      .done(function(stations) {
        //既存の結果一覧を削除
        $(".station-list").empty();
        
      if (stations.length == 0) {
        // 取得された駅が0件なら、駅が無い旨を表示
        addNoStation();
        } else {
          //インクリメンタルサーチで取得した駅一覧をフォームの下に表示
          stations.forEach(function(station){
            addStationToList(station);
          });
          // 駅一覧をクリックするとその駅の情報がフォームに入るようにする
          addClickEventListener();
        }
      })
      .fail(function() {
        alert("駅名が取得できませんでした...");
      });
    }
  });
});