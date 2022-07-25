$(document).on('turbolinks:load', function() {
  $('#school_type').on('change', function() {
    const val = $('#school_type').val();
    $.ajax({
      type: 'GET',
      url: "/microposts/get_selected_school_type",
      data: { selected_school_type: val }
    });
  });
});