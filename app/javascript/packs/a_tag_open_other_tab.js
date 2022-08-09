$(document).on('turbolinks:load', (function() {
  $('#toast_viewer').find("a[href^='http']:not([href*='" + location.hostname + "'])").attr({target: '_blank', rel: 'noopener noreferrer'});
}));

require("packs/a_tag_open_other_tab")