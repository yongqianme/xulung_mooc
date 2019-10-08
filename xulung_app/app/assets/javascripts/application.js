// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//= require jquery
//= require jquery_ujs
//= require back-to-top
//= require jquery-1.11.1.min
//= require jquery-migrate-1.2.1.min
//= require bootstrap.min
//= require jquery.easing.min

//= require waypoints.min
//= require jquery.counterup.min
//= require owl.carousel
//= require jquery.themepunch.tools.min
//= require jquery.themepunch.revolution.min
//= require jquery.cubeportfolio.min
//= require one.app
//= require pace-loader
//= require style-switcher
//= require jquery.mousewheel
//= require jquery.pjax
//= require jquery.infinite-pages
//= require nprogress
//= require nprogress-turbolinks
//= require simditor
//= require simditor/simditor-fullscreen
//= require simditor/marked.min
//= require simditor/to-markdown
//= require simditor/simditor-markdown
//= require social-share-button

$(function() {
  return $('.infinite-table').infinitePages({
    loading: function() {
      return $(this).text('Loading next page...');
    },
    error: function() {
      return $(this).button('There was an error, please try again');
    }
  });
});
