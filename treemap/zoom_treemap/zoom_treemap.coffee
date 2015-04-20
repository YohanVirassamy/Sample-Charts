$(document).ready ->

    data = zoom_treemap

    window.height = 500
    window.width = 500
    window.xscale = d3.scale.linear().range([0, width])
    window.yscale = d3.scale.linear().range([0, height])
    window.color = d3.scale.category10()
    window.headerHeight = 20
    window.headerColor = "#555555"
    window.transitionDuration = 500

    window.treemap = d3.layout.treemap()
        .round(false)
        .size([width, height])
        .sticky(true)
        .value((d) -> d.size)

    window.chart = d3.select("#body")
        .append("svg:svg")
        .attr("width", width)
        .attr("height", height)
        .append("svg:g")

    window.node = window.root = data
    nodes = treemap.nodes(root)

    children = nodes.filter((d) -> !d.children)
    parents = nodes.filter((d) -> d.children)

    #create parent cells
    parentCells = chart.selectAll("g.cell.parent")
        .data(parents, (d) -> "p-" + d.name)

    parentEnterTransition = parentCells.enter()
        .append("g")
        .attr("class", "cell parent")
        .on("click", (d) -> 
            zoom(d)
            return)
        .append("svg")
        .attr("class", "clip")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", headerHeight)

    parentEnterTransition.append("rect")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", headerHeight)
        .style("fill", headerColor)

    parentEnterTransition.append("text")
        .attr("class", "label")
        .attr("id", (d) -> d.dy)
        .attr("transform", "translate(3, 13)")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", headerHeight)
        .text((d) -> d.name)

    # update transition
    parentUpdateTransition = parentCells.transition().duration(transitionDuration)
    parentUpdateTransition.select(".cell")
        .attr("transform", (d) -> "translate(" + d.dx + "," + d.y + ")")

    parentUpdateTransition.select("rect")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", headerHeight)
        .style("fill", headerColor)

    parentUpdateTransition.select(".label")
        .attr("transform", "translate(3, 13)")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", headerHeight)
        .text((d) -> d.name)

    # remove transition
    parentCells.exit()
        .remove()

    # create children cells
    childrenCells = chart.selectAll("g.cell.child")
        .data(children, (d) -> "c-" + d.name)

    # enter transition
    childEnterTransition = childrenCells.enter()
        .append("g")
            .attr("class", "cell child")
            .on("click", (d) ->
                zoom(if node == d.parent then root else d.parent)
                return)
            .append("svg")
            .attr("class", "clip")

    childEnterTransition.append("rect")
        .classed("background", true)
        .style("fill" , (d) ->
                color(d.parent.name))

    childEnterTransition.append("text")
        .attr("class", "label")
        .attr("x", (d) -> d.dx / 2)
        .attr("y", (d) -> d.dy / 2)
        .attr("dy", ".35em")
        .attr("text-anchor", "middle")
        .style("display", "none")
        .text((d) -> d.name)

    # update transition
    childUpdateTransition = childrenCells.transition().duration(transitionDuration)
    childUpdateTransition.select(".cell")
        .attr("transform", (d) -> "translate(" + d.x + "," + d.y + ")")

    childUpdateTransition.select("rect")
        .attr("width", (d) -> Math.max(0.01, d.dx))
        .attr("height", (d) -> d.dy)
        .style("fill", (d) ->
                color(d.parent.name))

    childUpdateTransition.select(".label")
        .attr("x", (d) -> d.dx / 2)
        .attr("y", (d) -> d.dy / 2)
        .attr("dy", ".35em")
        .attr("text-anchor", "middle")
        .text((d) -> d.name)

    # exit transition
    childrenCells.exit()
        .remove()

    d3.select("select").on("change", ->
        console.log("select zoom(node)")
        treemap.value(if this.value == "size" then size else count )
            .nodes(root)
        zoom(node)
        return)

    zoom(node)
    return

