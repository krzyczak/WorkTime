// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

months = ['Styczeń','Luty','Marzec','Kwiecień','Maj','Czerwiec','Lipiec','Sierpień','Wrzesień','Październik','Listopad','Grudzień'];
$(function() {
  $(".calendar").datepicker({ dateFormat: 'dd-mm-yy', monthNames: months });
});
