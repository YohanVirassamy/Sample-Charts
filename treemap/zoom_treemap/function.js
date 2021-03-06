// Generated by CoffeeScript 1.9.0
(function() {
  $(document).ready(function() {
    window.size = function(d) {
      return d.size;
    };
    window.count = function(d) {
      return 1;
    };
    window.textHeight = function(d) {
      var ky;
      ky = height / d.dy;
      yscale.domain([d.y, d.y + d.dy]);
      return (ky * d.dy) / headerHeight;
    };
    window.getRGBComponents = function(color) {
      var b, g, r;
      r = color.substring(1, 3);
      g = color.substring(3, 5);
      b = color.substring(5, 7);
      return {
        R: parseInt(r, 16),
        G: parseInt(g, 16),
        B: parseInt(b, 16)
      };
    };
    window.idealTextColor = function(bgColor) {
      var bgDelta, components, nThreshold;
      nThreshold = 105;
      components = getRGBComponents(bgColor);
      bgDelta = components.R * 0.299 + components.G * 0.587 + components.B * 0.114;
      if (255 - bgDelta < nThreshold) {
        return '#000000';
      } else {
        return '#ffffff';
      }
    };
    window.zoom = function(d) {
      var kx, ky, level, zoomTransition;
      console.log(d);
      this.treemap.padding([headerHeight / (height / d.dy), 0, 0, 0]).nodes(d);
      kx = width / d.dx;
      ky = height / d.dy;
      level = d;
      xscale.domain([d.x, d.x + d.dx]);
      yscale.domain([d.y, d.y + d.dy]);
      if (node !== level) {
        chart.selectAll(".cell.child .label").style("display", "none");
      }
      zoomTransition = chart.selectAll("g.cell").transition().duration(transitionDuration).attr("transform", function(d) {
        return "translate(" + xscale(d.x) + "," + yscale(d.y) + ")";
      }).each("start", function() {
        d3.select(this).select("label").style("display", "none");
      }).each("end", function(d, i) {
        if (!i && (level !== root)) {
          chart.selectAll(".cell.child").attr("id", "hoho").filter(function(d) {
            return d.parent === node;
          }).select(".label").style("display", "").style("fill", function(d) {
            return idealTextColor(color(d.parent.name));
          });
        }
      });
      zoomTransition.select(".clip").attr("width", function(d) {
        return Math.max(0.01, kx * d.dx);
      }).attr("height", function(d) {
        if (d.children) {
          return headerHeight;
        } else {
          return Math.max(0.01, ky * d.dy);
        }
      });
      zoomTransition.select(".label").attr("width", function(d) {
        return Math.max(0.01, kx * d.dx);
      }).attr("height", function(d) {
        if (d.children) {
          return headerHeight;
        } else {
          return Math.max(0.01, ky * d.dy);
        }
      }).text(function(d) {
        return d.name;
      });
      zoomTransition.select(".child .label").attr("x", function(d) {
        return kx * d.dx / 2;
      }).attr("y", function(d) {
        return ky * d.dy / 2;
      });
      zoomTransition.select("rect").attr("width", function(d) {
        return Math.max(0.01, kx * d.dx);
      }).attr("height", function(d) {
        if (d.children) {
          return headerHeight;
        } else {
          return Math.max(0.01, ky * d.dy);
        }
      }).style("fill", function(d) {
        if (d.children) {
          return headerColor;
        } else {
          return color(d.parent.name);
        }
      });
      window.node = d;
      if (d3.event) {
        d3.event.stopPropagation();
      }
    };
  });

}).call(this);
