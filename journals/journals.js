// Generated by CoffeeScript 1.9.0
(function() {
  $(document).ready(function() {
    var queries, url;
    queries = window.queries;
    url = "http://127.0.0.1:5000/get_engine_data";
    $.ajax({
      'url': url,
      'method': 'POST',
      'data': {
        'query': JSON.stringify(queries.query_sessions_per_month_browser)
      }
    }).done(function(data) {
      var circles, color, g, height, j, margin, mouseout, mouseover, position, rMax, rMin, rScale, svg, text, truncate, width, x, xAxis, xScale, _results;
      data = format_data(data);
      truncate = function(str, maxLength, suffix) {
        if (str.length > maxLength) {
          str = str.substring(0, maxLength + 1);
          str = str.substring(0, Math.min(str.length, str.lastIndexOf(" ")));
          str = str + suffix;
        }
        return str;
      };
      mouseover = function(p) {
        var g;
        g = d3.select(this).node().parentNode;
        d3.select(g).selectAll("circle").style("display", "none");
        d3.select(g).selectAll("text.value").style("display", "block");
      };
      mouseout = function(p) {
        var g;
        g = d3.select(this).node().parentNode;
        d3.select(g).selectAll("circle").style("display", "block");
        d3.select(g).selectAll("text.value").style("display", "none");
      };
      margin = {
        top: 20,
        right: 200,
        bottom: 0,
        left: 20
      };
      width = 50 * data.period.length;
      height = 50 * data.browser.length;
      color = d3.scale.category20c();
      rMin = 2;
      rMax = 16;
      x = d3.scale.ordinal().domain(data.period).rangePoints([0, width]);
      xAxis = d3.svg.axis().scale(x).orient("top");
      svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).style("margin-left", margin.left + "px").append("g").attr("transform", "translate(" + margin.left + ", " + margin.top + ")");
      xScale = d3.scale.ordinal().domain(data.period).rangePoints([0, width]);
      position = xScale.range();
      svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + 0. + ")").call(xAxis);
      j = 0;
      _results = [];
      while (j < data.browser.length) {
        g = svg.append("g").attr("class", "journal");
        circles = g.selectAll("circle").data(data.browser[j].data_month).enter().append("circle");
        text = g.selectAll("text").data(data.browser[j].data_month).enter().append("text");
        rScale = d3.scale.linear().domain([
          0, d3.max(data.browser[j].data_month, function(d) {
            return d.value;
          })
        ]).range([rMin, rMax]);
        circles.attr("cx", function(d) {
          return position[data.period.indexOf(d.month)];
        }).attr("cy", j * 40 + 20).attr("r", function(d) {
          return rScale(d.value);
        }).style("fill", function(d) {
          return color(j);
        });
        text.attr("y", j * 40 + 25).attr("x", function(d) {
          return position[data.period.indexOf(d.month)] - (width / 70);
        }).attr("class", "value").text(function(d) {
          return d.value;
        }).style("fill", function(d) {
          return color(j);
        }).style("display", "none");
        g.append("text").attr("y", j * 40 + 25).attr("x", width + 20).attr("class", "label").text(truncate(data.browser[j].name, 30, "...")).style("fill", function(d) {
          return color(j);
        }).on("mouseover", mouseover).on("mouseout", mouseout);
        _results.push(j++);
      }
      return _results;
    });
  });

}).call(this);
