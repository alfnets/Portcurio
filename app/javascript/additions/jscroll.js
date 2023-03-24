$(document).on('turbolinks:load',function(){
    const jscrollOption = {
        loadingHtml: '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading...</div>', //記事読み込み中の表示
        autoTrigger: true, // 自動で読み込むか否か、trueで自動、falseでボタンクリックとなる。
        padding: 20, // 指定したコンテンツの下かた何pxで読み込むかを指定(autoTrigger: trueの場合のみ)
        contentSelector: '.jscroll', // 読み込む範囲の指定
        nextSelector: "a[rel='next']"
    };

    const jscrollReactionOption = {
        loadingHtml: '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading...</div>',
        autoTrigger: true,
        padding: 20,
        contentSelector: '.jscroll-reaction',
        nextSelector: "a[rel='next']"
    };

    $('.jscroll').jscroll(jscrollOption);
    $('.jscroll-reaction').jscroll(jscrollReactionOption);
});

