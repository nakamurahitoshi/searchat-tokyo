$(function(){

  function buildHTML(message){

    // コメント欄のユーザー名の横に獲得したポイントのレベルを表記する
    var point
      if (message.user_point < 100){
        point = 1
      }else if (message.user_point < 200){
        point = 2
      }else if (message.user_point < 300){
        point = 3
      }else if (message.user_point < 400){
        point = 4
      }else if (message.user_point < 500){
        point = 5
      }else{
        point = Max
      }
    // #タグがあればリンクを生成し、そうでなければしない
    var hashtag_link
    if ((message.body).split(/[#]/)[1] != null){
      hashtag_link = 
                    `<a class="message1__text_hashtag" data-method="GET" href="/stations/${message.station_id}/messages/${message.id}?keyword=${encodeURI((message.body).split(/[#]/)[1])}&amp;user_id=${message.user_id}">
                    ${(message.body).split(/[#]/)[1]}
                    </a>
                    <i id="message1__text__icon" class="fa fa-heart">
                    </i>
                    <a class="message1__text__arrows" data-method="GET" href="/stations/${message.station_id}/messages/${message.id}?keyword=${encodeURI((message.body).split(/[#]/)[1])}&amp;user_id=${message.user_id}">
                    ←
                 </a>`
    }else{
      hashtag_link = ""
    }

    var html = `<div class="message1" data-messageid="${message.id}">
                  <div class="message1__info">
                    <div class="message1__username">
                    ${message.user_name}
                    </div>
                    <div class="message1__userpoint-level">
                    Lv.
                    </div>
                    <div class="message1__userpoint-level__number">
                    ${point}
                    </div>
                    <div class="message1__date">
                    ${message.created_at}
                    </div>
                    <div class="btn__delete-btn" data-station-id=${message.station_id} data-message-id=${message.id}>削除</div>
                  </div>
                  <div class="message1__body">
                    <p class="message1__text">
                    ${message.body}
                    </p>
                    ${hashtag_link}
                  </div>
                </div>`
    return html;
  }
  
    //ajax通信によりメッセージを削除する関数
    function delete_message(obj, url, data_hash){
      //完了を知らせるDeferredオブジェクトを生成
      var deferred = new $.Deferred();
      $.ajax({
        url: url,
        type: 'DELETE',
        data: data_hash ,
        dataType: 'json',
      })
      .done(function(data){
        obj.parent().parent().remove()
      })
      .fail(function(){
        alert('削除に失敗しました');
      }).always(function(){
        //ajax処理終了をDeferredオブジェクトに通知
        deferred.resolve();
      });
      //完了を知らせるDeferredオブジェクトを生成し返す
      return deferred;
    }

  $(document).on('click', '.btn__delete-btn' ,function(){
    var del_confirm = window.confirm("メッセージを削除してもよろしいですか?");
    if( del_confirm ) {
      obj = $(this)
      var stationid = $(this).data('station-id');
      var messageid = $(this).data('message-id');
      var url = `/stations/${stationid}/messages/${messageid}`;
      var data_hash = {id: messageid}
      alert("メッセージを削除します")
      var deferred = delete_message(obj, url, data_hash)
      deferred.done(function(){
        alert("メッセージを削除しました")
      });
    }
  });

  // コメントが空白のときは送信ボタンを無効化する
  $(".form__message").on('keyup' ,function(){
    // 入力フォームが入力されたら、送信ボタンを有効化する
    if ($(this).val() != ""){
      //送信ボタンのdisalbedを外す
      $(".form__button").prop("disabled", false);
    }else{
      //送信ボタンにdisalbedを設定する
      $(".form__button").prop("disabled", true);
    }
  })

  $('.form__box').on('submit', function(e){
    e.preventDefault()
    var formData = new FormData(this);
    var url = $(this).attr('action');
    $.ajax({
      url: url,
      type: 'POST',
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.messages').append(html);
      $('.messages').animate({scrollTop: $('.messages')[0].scrollHeight}, 'fast');
      $('.form__box')[0].reset();
    })
    .fail(function(){
      alert('メッセージ送信に失敗しました');
    })
    .always(function(){
      $('.form__button').prop("disabled",false);
    })
  });  
});