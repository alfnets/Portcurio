$(document).on("turbolinks:load", function () {
  if (location.search.indexOf('tab=responses') != -1) {
    $('#materials_tab').removeClass('active');
    $('#microposts_tab').removeClass('active');
    $('#responses_tab').addClass('active');
  } else if (location.search.indexOf('tab=microposts') != -1) {
    $('#materials_tab').removeClass('active');
    $('#microposts_tab').addClass('active');
    $('#responses_tab').removeClass('active');
  } else {
    $('#materials_tab').addClass('active');
    $('#microposts_tab').removeClass('active');
    $('#responses_tab').removeClass('active');
  }
});
