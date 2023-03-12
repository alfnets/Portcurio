$(document).on("turbolinks:load", function () {
  const micropostTitle = $("#micropost_title");
  const micropostEducationalMaterial = $("#micropost_educational_material");

  micropostEducationalMaterial.on("change", (ev) => {
    if (ev.target.checked) {
      micropostTitle.fadeIn(200);
    } else {
      micropostTitle.fadeOut(200, () => {
        micropostTitle.val("");
      });
    }
  });
});
