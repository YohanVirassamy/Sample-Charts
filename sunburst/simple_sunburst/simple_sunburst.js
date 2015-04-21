// Generated by CoffeeScript 1.9.0
(function() {
  $(document).ready(function() {
    var arc, arcTween, color, data, height, partition, path, radius, stash, svg, width;
    stash = function(d) {
      d.x0 = d.x;
      d.dx0 = d.dx;
    };
    arcTween = function(a) {
      var i;
      i = d3.interpolate({
        x: a.x0,
        dx: a.dx0
      }, a);
      return function(t) {
        var b;
        b = i(t);
        a.x0 = b.x;
        a.dx0 = b.dx;
        return arc(b);
      };
    };
    d3.select(self.frameElement).style("height", height + "px");
    data = simple_sunburst;
    width = 960;
    height = 700;
    radius = Math.min(width, height) / 2;
    color = d3.scale.category20c();
    svg = d3.select("body").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height * 0.50 + ")");
    partition = d3.layout.partition().sort(null).size([2 * Math.PI, radius * radius * 0.9]).value(function(d) {
      return 1;
    });
    arc = d3.svg.arc().startAngle(function(d) {
      return d.x;
    }).endAngle(function(d) {
      return d.x + d.dx;
    }).innerRadius(function(d) {
      return Math.sqrt(d.y);
    }).outerRadius(function(d) {
      return Math.sqrt(d.y + d.dy);
    });
    path = svg.datum(data).selectAll("path").data(partition.nodes).enter().append("path").attr("display", function(d) {
      if (d.depth) {
        return null;
      } else {
        return "none";
      }
    }).attr("d", arc).style("stroke", "#fff").style("fill", function(d) {
      return color((d.children ? d : d.parent).name);
    }).style("fill-rule", "evenodd").each(stash);
    d3.selectAll("input").on("change", function() {
      var value;
      value = this.value === "count" ? (function() {
        return 1;
      }) : (function(d) {
        return d.size;
      });
      path.data(partition.value(value).nodes).transition().duration(1500).attrTween("d", arcTween);
    });
  });

}).call(this);
