$(document).on("turbolinks:load", function () {
  $("#user_image").on("change", function (e) {
    const files = e.target.files;
    const file = e.target.files[0];
    if (files.length === 0) {
      $("#icon_preview").html("");
      $("#icon_image").css({'display':'block'});
    } else {
      const reader = new FileReader();
      const img = new Image();
      reader.onload = function (e) {
        // 画像を表示
        $("#icon_image").css({'display':'none'});
        $("#icon_preview").empty();
        $("#icon_preview").append(img);
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  });
});

require("packs/icon_preview")