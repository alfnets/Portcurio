// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@fortawesome/fontawesome-free/js/all";
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
require("jquery");
import "bootstrap";

require("additions/jscroll");
require("additions/micropost_show_open");
require("additions/micropost_title");
require("additions/user_show_close_by_tab");
require("additions/bootstrap.offcanvas");
require("additions/get_selected_school_type_for_microposts");
require("additions/get_selected_school_type_for_users");
require("additions/bootstrap-tagsinput");
require("additions/resize_sidebar_height");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.addEventListener("load", () => {
  navigator.serviceWorker
    .register("/service-worker.js")
    .then((registration) => {
      console.log("ServiceWorker registered: ", registration);

      var serviceWorker;
      if (registration.installing) {
        serviceWorker = registration.installing;
        console.log("Service worker installing.");
      } else if (registration.waiting) {
        serviceWorker = registration.waiting;
        console.log("Service worker installed & waiting.");
      } else if (registration.active) {
        serviceWorker = registration.active;
        console.log("Service worker active.");
      }
    })
    .catch((registrationError) => {
      console.log("Service worker registration failed: ", registrationError);
    });
});
