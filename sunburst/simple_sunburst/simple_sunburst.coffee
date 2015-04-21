$(document).ready ->

    # functions

    stash = (d) ->
        d.x0 = d.x
        d.dx0 = d.dx
        return

    arcTween = (a) ->
        i = d3.interpolate({x: a.x0, dx: a.dx0}, a)
        (t) -> 
            b = i(t)
            a.x0 = b.x
            a.dx0 = b.dx
            arc(b)

    d3.select(self.frameElement).style("height", height + "px")

    data = simple_sunburst

    width = 960
    height = 700
    radius = Math.min(width, height) / 2
    color = d3.scale.category20c()

    svg = d3.select("body").append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height * 0.50 + ")")

    partition = d3.layout.partition()
        .sort(null)
        .size([2 * Math.PI, radius * radius * 0.9])
        .value((d) -> 1)

    arc = d3.svg.arc()
        .startAngle((d) -> d.x)
        .endAngle((d) -> d.x + d.dx)
        .innerRadius((d) -> Math.sqrt(d.y))
        .outerRadius((d) -> Math.sqrt(d.y + d.dy))

    path = svg.datum(data).selectAll("path")
        .data(partition.nodes)
      .enter().append("path")
        .attr("display", (d) ->  if d.depth then null else "none")
        .attr("d", arc)
        .style("stroke", "#fff")
        .style("fill", (d) -> color((if d.children then d else d.parent).name))
        .style("fill-rule", "evenodd")
        .each(stash)

    d3.selectAll("input").on("change",  ->
        value = if this.value is "count" then (-> 1) else ((d) -> d.size)

        path
            .data(partition.value(value).nodes)
          .transition()
            .duration(1500)
            .attrTween("d", arcTween)

        return)

    return

