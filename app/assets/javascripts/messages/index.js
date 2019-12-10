$(function(){

  function buildHTML(message){
    var html = `<div class="message1" data-messageid="${message.id}">
                  <div class="message1__info">
                    <div class="message1__username">
                    ${message.user_name}
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
                    <a class="message1__text_hashtag" data-method="GET" href="/stations/${message.station_id}/messages/${message.id}?keyword=${encodeURI((message.body).split(/[#]/)[1])}&amp;user_id=${message.user_id}">
                    ${(message.body).split(/[#]/)[1]}
                    </a>
                  </div>
                </div>`
    return html;
  }
  
  $(document).on('click', '.btn__delete-btn' ,function(){
    obj = $(this)
    var stationid = $(this).data('station-id');
    var messageid = $(this).data('message-id');
    var url = `/stations/${stationid}/messages/${messageid}`;
    $.ajax({
      url: url,
      type: 'DELETE',
      data: {id: messageid},
      dataType: 'json',
    })
    .done(function(data){
      obj.parent().parent().remove()
    })
    .fail(function(){
      alert('削除に失敗しました');
    })
  });

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