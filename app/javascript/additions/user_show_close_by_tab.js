$(document).on('turbolinks:load',function(){
  $('#comments-and-likes-tab').on('click', () => {
    $('.comments-container').html('');
    $('.comment-close-btn').html('');
  });
});

