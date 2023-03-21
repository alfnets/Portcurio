$(window).on('turbolinks:load', function() {
  updateSidebarHeight();
});

$(window).on('turbolinks:resize', updateSidebarHeight);

function updateSidebarHeight() {
  const mainContentHeight = $('main').height();
  const windowHeight = $(window).innerHeight();
  const sidebarHeight = Math.min(mainContentHeight, windowHeight);
  $('aside').height(sidebarHeight);
}
