$(document).on("turbolinks:load", function () {
  $("#user_image").on("change", function (e) {
    const files = e.target.files;
    if (files.length === 0) {
      $("#image_preview").html("");
      $('#image_preview').css({'max-width':'0px','padding-bottom':'0px'});
    } else {
      const d = new $.Deferred().resolve();
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
      $('#image_preview').css({ 'max-width': '300px', 'padding-bottom': '16px' });
      $("#image_preview").empty();
      $("#image_preview").append(img);
      img.src = e.target.result;
      def.resolve(img);
      $('#image_preview img').css('width', '100%');
    };
    reader.readAsDataURL(imageFile);
    return def.promise();
  }
});