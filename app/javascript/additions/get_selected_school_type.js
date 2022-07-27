$(document).on('turbolinks:load', function() {
  $('#micropost_school_type').on('change', function() {
    const val = $('#micropost_school_type').val();
    $.ajax({
      type: 'GET',
      url: "/microposts/get_selected_school_type",
      data: { selected_school_type: val }
    });
  });
});
