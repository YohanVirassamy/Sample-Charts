// Generated by CoffeeScript 1.9.0
(function() {
  $(document).ready(function() {
    var get_data_value;
    get_data_value = function(browser) {
      var data_value, i;
      i = 0;
      while (i < data.length) {
        if (data.browser[i].name === browser) {
          data_value = data.browser[i].value;
          break;
        } else {
          i++;
        }
      }
      return data_value;
    };
    $(".bar").hover(function() {
      var get_browser;
      get_browser = $(this).attr("id");
      $(this).css("fill", "red");
      $("#main_zone").css("opacity", 1);
      $(".info_browser").text(get_browser);
      return $(".info_value").text(get_data_value(get_browser));
    }, function() {
      $("#main_zone").css("opacity", 0);
      return $(this).css("opacity", 1);
    });
  });

}).call(this);
