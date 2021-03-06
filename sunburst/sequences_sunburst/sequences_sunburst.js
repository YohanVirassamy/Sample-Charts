// Generated by CoffeeScript 1.9.0
(function() {
  $(document).ready(function() {
    var arc, breadcrumb, breadcrumbPoints, buildHierarchy, colors, createVisualization, data, drawLegend, formatName, getAncestors, height, initializeBreadcrumbTrail, mouseleave, mouseover, partition, radius, toggleLegend, totalSize, updateBreadcrumbs, vis, width;
    data = flare;
    colors = window.colors;
    width = 750;
    height = 600;
    radius = Math.min(width, height) / 2;
    breadcrumb = {
      b_width: 75,
      b_height: 30,
      b_spacing: 3,
      b_tip_tail: 10
    };
    totalSize = 0;
    vis = d3.select("#chart").append("svg:svg").attr("width", width).attr("height", height).append("svg:g").attr("id", "container").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
    partition = d3.layout.partition().size([2 * Math.PI, radius * radius * 0.9]).value(function(d) {
      return d.size;
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
    createVisualization = function(json) {
      var nodes, path;
      initializeBreadcrumbTrail();
      drawLegend();
      d3.select("#togglelegend").on("click", toggleLegend);
      vis.append("svg:circle").attr("r", radius).style("opacity", 0);
      nodes = partition.nodes(json).filter(function(d) {
        return d.dx > 0.005;
      });
      path = vis.data([json]).selectAll("path").data(nodes).enter().append("svg:path").attr("display", function(d) {
        if (d.depth) {
          return null;
        } else {
          return "none";
        }
      }).attr("d", arc).attr("fill-rule", "evenodd").style("fill", "red").style("opacity", 1).on("mouseover", mouseover);
      d3.select("#container").on("mouseleave", mouseleave);
      totalSize = path.node().__data__.value;
    };
    mouseover = function(d) {
      var percentage, percentageString, sequenceArray;
      percentage = (100 * d.value / totalSize).toPrecision(3);
      percentageString = percentage + "%";
      if (percentage < 0.1) {
        percentageString = "< 0.1%";
      }
      d3.select("#percentage").text(percentageString);
      d3.select("#children_name").text(formatName(d.name));
      d3.select("#explanation").style("visibility", "");
      sequenceArray = getAncestors(d);
      updateBreadcrumbs(sequenceArray, percentageString);
      d3.selectAll("path").style("opacity", 0.3);
      vis.selectAll("path").filter(function(node) {
        return sequenceArray.indexOf(node) >= 0;
      }).style("opacity", 1);
    };
    mouseleave = function(d) {
      d3.select("#trail").style("visibility", "hidden");
      d3.selectAll("path").on("mouseover", null);
      d3.selectAll("path").transition().duration(1000).style("end", function() {
        d3.select(this).on("mouseover", mouseover);
      });
      d3.select("#explanation").style("visibility", "hidden");
    };
    getAncestors = function(node) {
      var current, path;
      path = [];
      current = node;
      while (current.parent) {
        path.unshift(current);
        current = current.parent;
      }
      return path;
    };
    initializeBreadcrumbTrail = function() {
      var trail;
      trail = d3.select("#sequence").append("svg:svg").attr("width", width).attr("height", 50).attr("id", "trail");
      trail.append("svg:text").attr("id", "endlabel").style("fill", "#000");
    };
    breadcrumbPoints = function(d, i) {
      var points;
      points = [];
      points.push("0,0");
      points.push(breadcrumb.b_width + ",0");
      points.push(breadcrumb.b_width + breadcrumb.b_tip_tail + "," + (breadcrumb.b_height / 2));
      points.push(breadcrumb.b_width + "," + breadcrumb.b_height);
      points.push("0," + breadcrumb.b_height);
      if (i > 0) {
        points.push(breadcrumb.b_tip_tail + "," + (breadcrumb.b_height / 2));
      }
      return points.join(" ");
    };
    updateBreadcrumbs = function(nodeArray, percentageString) {
      var entering, g;
      g = d3.select("#trail").selectAll("g").data(nodeArray, function(d) {
        return d.name + d.depth;
      });
      entering = g.enter().append("svg:g");
      entering.append("svg:polygon").attr("points", breadcrumbPoints).style("fill", "blue");
      entering.append("svg:text").attr("id", "name_trail").attr("x", (breadcrumb.b_width + breadcrumb.b_tip_tail) / 2).attr("y", breadcrumb.b_height / 2).attr("dy", "0.35em").attr("text-anchor", "middle").text(function(d) {
        return d.name;
      });
      g.attr("transform", function(d, i) {
        return "translate(" + i * (breadcrumb.b_width + breadcrumb.b_spacing) + ",0)";
      });
      g.exit().remove();
      d3.select("#trail").select("#endlabel").attr("x", (nodeArray.length + 0.5) * (breadcrumb.b_width + breadcrumb.b_spacing)).attr("y", breadcrumb.b_height / 2).attr("dy", "0.35em").attr("text-anchor", "middle").text(percentageString);
      d3.select("#trail").style("visibility", "");
    };
    drawLegend = function() {
      var g, legend, li;
      li = {
        w: 75,
        h: 30,
        s: 3,
        r: 3
      };
      legend = d3.select("#legend").append("svg:svg").attr("width", li.w).attr("height", d3.keys(colors).length * (li.h + li.s));
      g = legend.selectAll("g").data(d3.entries(colors)).enter().append("svg:g").attr("transform", function(d, i) {
        return "translate(0," + i * (li.h + li.s) + ")";
      });
      g.append("svg:rect").attr("rx", li.r).attr("ry", li.r).attr("width", li.w).attr("height", li.h).style("fill", function(d) {
        return d.value;
      });
      g.append("svg:text").attr("x", li.w / 2).attr("y", li.h / 2).attr("dy", "0.35em").attr("text-anchor", "middle").style("fill", function(d) {
        return d.key;
      });
    };
    toggleLegend = function() {
      var legend;
      legend = d3.select("#legend");
      if (legend.style("visibility") === "hidden") {
        legend.style("visibility", "");
      } else {
        legend.style("visibility", "hidden");
      }
    };
    formatName = function(name) {
      var i;
      if (name.length < 15) {
        return name;
      } else {
        i = name.length;
        while (i > 0) {
          if (name.charCodeAt(i) > 64 && name.charCodeAt(i) < 91) {
            name = name.substring(0, i) + "\n" + name.substring(i);
            break;
          }
          i--;
        }
        return name;
      }
    };
    buildHierarchy = function(csv) {
      var childNode, children, currentNode, foundChild, i, j, k, nodeName, parts, root, sequence, size;
      root = {
        "name": "root",
        "children": []
      };
      i = 0;
      while (i < csv.length) {
        sequence = csv[i][0];
        size = +csv[i][1];
        if (isNaN(size)) {
          i++;
          continue;
        }
        parts = sequence.split("-");
        currentNode = root;
        j = 0;
        while (j < parts.length) {
          children = currentNode["children"];
          nodeName = parts[j];
          childNode;
          if (j + 1 < parts.length) {
            foundChild = false;
            k = 0;
            while (k < children.length) {
              if (children[k]["name"] === nodeName) {
                childNode = children[k];
                foundChild = true;
                break;
              }
              k++;
            }
            if (!foundChild) {
              childNode = {
                "name": nodeName,
                "children": []
              };
              children.push(childNode);
            }
            currentNode = childNode;
          } else {
            childNode = {
              "name": nodeName,
              "size": size
            };
            children.push(childNode);
          }
          j++;
        }
        i++;
      }
      return root;
    };
    console.log(data);
    createVisualization(data);
  });

}).call(this);
