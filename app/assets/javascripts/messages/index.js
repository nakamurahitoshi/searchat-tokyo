$(function(){

  function buildHTML(message){
    var html = `<div class="message" data-messageid="${message.id}">
                  <div class="message__info">
                    <div class="message__username">
                    ${message.user_name}
                    </div>
                    <div class="message__date">
                    ${message.created_at}
                    </div>
                  </div>
                  <div class="message__body">
                    <p class="message__text">
                    ${message.body}
                    </p>
                  </div>
                </div>`
    return html;
  }

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