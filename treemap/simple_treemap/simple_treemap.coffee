$(document).ready ->

    data = simple_treemap

    top = 40
    bottom = 10
    left = 10
    right = 10

    width = 960 - left - right
    height = 500 - top - bottom

    color = d3.scale.category20c()

    treemap = d3.layout.treemap()
        .size([width, height])
        .sticky(true)
        .value((d) -> d.size)

    div = d3.select("body").append("div")
        .style("position", "relative")
        .style("width", (width + left + right ) + "px")
        .style("height", (height + top + bottom ) + "px")
        .style("left" , left + "px")
        .style("top" , top + "px")

    position =  ->
        this
            .style("left", (d) -> d.x + "px")
            .style("top", (d) -> d.y + "px")
            .style("width", (d) -> Math.max(0, d.dx - 1) + "px")
            .style("height", (d) -> Math.max(0, d.dy - 1) + "px")

    node = div.datum(data).selectAll(".node")
        .data(treemap.nodes)
      .enter()
        .append("div")
            .attr("class", "node")
            .call(position)
            .style("background", (d) -> if d.children then color(d.name) else null)
        .text((d) -> if d.children then  null else d.name)

