$(function(){
  //ajax通信によりデータベースを更新する関数
  function update_database(){
    //完了を知らせるDeferredオブジェクトを生成
    var deferred = new $.Deferred();
    $.ajax({
      url: "/railways/0",
      type: 'PATCH',
      data: {},
      dataType: 'json',
    })
    .done(function(data){
    })
    .fail(function(){
      alert('データベース更新に失敗しました');
    }).always(function(){
      //ajax処理終了をDeferredオブジェクトに通知
      deferred.resolve();
    });
    //完了を知らせるDeferredオブジェクトを生成し返す
    return deferred;
  }

  // 透明なdivタグを貼って画面をロックさせる関数
  function screenLock(lock){
    if(lock){
     // 画面ロック
     // ロック用のdivを生成
     $("body").prepend(
       $("<div> <p>ただいま路線・駅データベースの更新中です しばらくお待ちください</p> </div>")
        .addClass("screenlock")
        .css({
          "height" : "100vh",
          "width" : "100vw",
          "position" : "absolute",
          "top" : "0px",
          "left" : "0px",
          "background-color" : "lightgray",
          "opacity" : "0.9",
          "line-height" : "50vh",
          "text-align" : "center",
          "zIndex" : "9999", //最上位に表示
          "font-size" : "xx-large",
          "font-weight" : "bold"  
      }));
    }else{
      // 画面ロックを解除
      // div要素を削除
      $(".screenlock").remove();
    }
  }
  
  $(".btn-update").on('click' ,function(){
    var update_confirm = window.confirm("路線・駅情報のデータベースを更新してもよろしいでしょうか \n 所要時間は約3分です");
    if( update_confirm ) {
      alert("データベースの更新を開始します。しばらくお待ちください");
      // 画面ロック開始　-> 画面全体に透明なdivタグを貼ることでロックする
      screenLock(true);
      var deferred = update_database();
      deferred.done(function(){
        // 画面ロック解除　-> 画面全体の透明なdivタグを取り除く
        screenLock(false);
        alert("データベースの更新が終了しました");
      });
    }
  });
});