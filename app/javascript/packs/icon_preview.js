$(document).on("turbolinks:load", function () {
  $("#user_image").on("change", function (e) {
    const files = e.target.files;
    if (files.length === 0) {
      $("#image_preview").html("");
      $("#icon_image").css({'display':'block'});
    } else {
      let d = new $.Deferred().resolve();
      $.each(files, function (i, file) {
        d = d.then(function () {
          return previewImage(file);
        });
      });
    }
  });

  function previewImage(imageFile) {
    const reader = new FileReader();
    const img = new Image();
    const def = $.Deferred();
    reader.onload = function (e) {
      // 画像を表示
      $("#icon_image").css({'display':'none'});
      $("#image_preview").empty();
      $("#image_preview").append(img);
      img.src = e.target.result;
      def.resolve(img);
    };
    reader.readAsDataURL(imageFile);
    return def.promise();
  }
});

require("packs/icon_preview")