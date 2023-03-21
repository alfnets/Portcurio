$(document).on("turbolinks:load", function () {
  // indexOf()メソッドは、指定した文字列が見つかった場合にその位置を返し、見つからなかった場合には-1を返す
  if (location.search.indexOf('?comment_open=true') != -1) {
    $(".show .btn-comment").trigger("click");

    const lastContentInfo = $('.content-info').last();
    $('html, body').animate({
      scrollTop: lastContentInfo.offset().top
      }, 500);
  }
});

// window.onload = function () {
//   $('.btn-comment').trigger('click');
// };
