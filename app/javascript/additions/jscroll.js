$(document).on('turbolinks:load',function(){
    var jscrollOption = {
        loadingHtml: '読み込み中・・・', //記事読み込み中の表示
        autoTrigger: true, // 自動で読み込むか否か、trueで自動、falseでボタンクリックとなる。
        padding: 20, // 指定したコンテンツの下かた何pxで読み込むかを指定(autoTrigger: trueの場合のみ)
        contentSelector: '.jscroll', // 読み込む範囲の指定
        nextSelector: "a[rel='next']"
    };
    $('.jscroll').jscroll(jscrollOption);
});