$(function() {
  // フォームとオートコンプリートを関連づける
  var input = $(".form__search__message").get(0);
  var options = {
    // 施設名と住所の情報を取得
    types: ['establishment'],
    // 検索範囲を日本
    componentRestrictions: {country: 'jp'}
  };
  // オートコンプリートオブジェクトの生成
  autocomplete = new google.maps.places.Autocomplete(input, options);
  // 施設名と住所をインクリメンタルサーチに表示させる
  autocomplete.setFields(['name','address_component']);
  // ユーザが場所一覧をクリックしたら、クリックされた場所をフォームに書き込む
  autocomplete.addListener('place_changed', function(){
    // 既存の文字を削除
    $(".form__search__message").val("");
    // autocompleteオブジェクトから場所の情報を取得クリックされた場所をフォームに入れる
    $(".form__search__message").val(this.getPlace().name);
  });
});