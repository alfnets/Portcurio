$(document).on('turbolinks:load', function() {
  $('#user_school_type').on('change', function() {
    const val = $('#user_school_type').val();
    $.ajax({
      type: 'GET',
      url: `/users/get_selected_school_type`,
      data: { selected_school_type: val }
    });
  });
});
