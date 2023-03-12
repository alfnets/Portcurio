$(document).on("turbolinks:load", function () {
  const micropostEducationalMaterial = $("#micropost_educational_material");
  const micropostTitle = $("#micropost_title");

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
