$(document).ready ->

    # functions
    window.size = (d) -> d.size

    window.count = (d) -> 1

    window.textHeight = (d) ->
        ky = height / d.dy
        yscale.domain([d.y, d.y + d.dy])
        return (ky * d.dy) / headerHeight

    window.getRGBComponents = (color) ->
        r = color.substring(1, 3)
        g = color.substring(3, 5)
        b = color.substring(5, 7)
        {
            R: parseInt(r, 16)
            G: parseInt(g, 16)
            B: parseInt(b, 16)
        }

    window.idealTextColor = (bgColor) ->
        nThreshold = 105
        components = getRGBComponents(bgColor)
        bgDelta = components.R * 0.299 + components.G * 0.587 + components.B * 0.114
        if 255 - bgDelta < nThreshold then '#000000' else '#ffffff'

    window.zoom = (d) ->
        console.log(d)
        this.treemap
            .padding([headerHeight / (height / d.dy), 0, 0, 0 ])
            .nodes(d)

        # moving the next two lines above treemap layout messes up padding of zoom result
        kx = width / d.dx
        ky = height / d.dy
        level = d

        xscale.domain [d.x, d.x + d.dx]
        yscale.domain [d.y, d.y + d.dy]

        if (node != level)
            chart.selectAll(".cell.child .label")
                .style("display", "none")

        zoomTransition = chart.selectAll("g.cell").transition().duration(transitionDuration)
            .attr("transform", (d) -> "translate(" + xscale(d.x) + "," + yscale(d.y) + ")")
            .each("start", ->
                d3.select(this).select("label")
                    .style("display", "none")
                return)
            .each("end", (d, i) ->
                if (!i and (level isnt root))
                    chart.selectAll(".cell.child")
                        .attr("id", "hoho")
                        .filter((d) -> d.parent is node)
                        .select(".label")
                        .style("display", "")
                        .style("fill", (d) -> idealTextColor(color(d.parent.name)))
                return)

        zoomTransition.select(".clip")
            .attr("width", (d) -> Math.max(0.01, (kx * d.dx)))
            .attr("height", (d) -> if d.children then headerHeight else  Math.max(0.01, (ky * d.dy)))

        zoomTransition.select(".label")
            .attr("width", (d) -> Math.max(0.01, (kx * d.dx)))
            .attr("height", (d) -> if d.children then headerHeight else  Math.max(0.01, (ky * d.dy)))
            .text((d) -> d.name)

        zoomTransition.select(".child .label")
            .attr("x", (d) -> kx * d.dx / 2)
            .attr("y", (d) -> ky * d.dy / 2)

        zoomTransition.select("rect")
            .attr("width", (d) -> Math.max(0.01, (kx * d.dx)))
            .attr("height", (d) -> if d.children then headerHeight else  Math.max(0.01, (ky * d.dy)))
            .style("fill", (d) -> if d.children then headerColor else color(d.parent.name))

        window.node = d

        if (d3.event)
            d3.event.stopPropagation()

        return

    return




