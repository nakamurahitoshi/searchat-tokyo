/// ユーザがお気に入り駅を登録する機能のJavascript ///
$(function() {
  // 駅チャットの星マークがクリックされたら、
  // ユーザidと非同期でusersコントローラのcreateアクションに送信する
  $(".chat-header__favorite-btn").on("click" ,function(){
      // 現在ページに表示されている駅のIDを取得
      var station_id = $(this).data("station-id");
    // 非お気に入り駅からお気に入り駅に変更するとき
    if ($(this).hasClass("chat-header__favorite-btn--no")){
      // 非同期通信を開始 
      // 非お気に入り駅->お気に入り駅を表すフラグ0を送信する
      $.ajax({
        url: "/users/create",
        type: "GET",
        data: {station_id: station_id, flag: 0}, 
        dataType: "json"
      })  
      .done(function(station) {
        // お気に入りマーク(星)の色を白色から黄色にするためにクラス名前を変更する
        $(".chat-header__favorite-btn--no").removeClass("chat-header__favorite-btn--no").addClass("chat-header__favorite-btn--yes");
        // my stationをお気に入り駅にする
        $(".mystation__name").text(station.name);
        $('.mystation-footer__nil').removeClass("mystation-footer__nil").addClass("mystation-footer__not-nil").text("↑↑駅名をクリックするとチャットに飛べるよ");
        $(".mystation-mark__body").text("My \n 01");
      })
      .fail(function() {
        alert("駅のお気に入り登録ができませんでした...");
      });
    }else{
      // 非同期通信を開始 
      // 非お気に入り駅->お気に入り駅を表すフラグ0を送信する
      $.ajax({
        url: "/users/create",
        type: "GET",
        data: {station_id: station_id, flag: 1}, 
        dataType: "json"
      })  
      .done(function(station) {
        // お気に入りマーク(星)の色を黄色から白色にするためにクラス名前を変更する
        $(".chat-header__favorite-btn--yes").removeClass("chat-header__favorite-btn--yes").addClass("chat-header__favorite-btn--no");
        // my stationを「なし」にする
        $(".mystation__name").text("お気に入りの駅を登録できます");
        $('.mystation-footer__not-nil').removeClass("mystation-footer__not-nil").addClass("mystation-footer__nil")
        $('.mystation-footer__nil').html(`<div class="mystation-footer__nil">
                                          チャット画面の<i class="fa fa-star"></i>をクリックしてね
                                        </div>`);
        $(".mystation-mark__body").text(" ");
      })
      .fail(function() {
        alert("駅のお気に入り解除ができませんでした...");
      });
    }
  });
});