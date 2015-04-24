$(document).ready ->

    data = flare
    colors = window.colors

    width = 750
    height = 600
    radius = Math.min(width, height) / 2

    breadcrumb = {
        b_width: 75
        b_height: 30
        b_spacing: 3
        b_tip_tail: 10
    }


    totalSize = 0

    vis = d3.select("#chart").append("svg:svg")
        .attr("width", width)
        .attr("height", height)
        .append("svg:g")
        .attr("id", "container")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

    partition = d3.layout.partition()
        .size([2 * Math.PI, radius * radius * 0.9])
        .value((d) -> d.size)

    arc = d3.svg.arc()
        .startAngle((d) -> d.x)
        .endAngle((d) -> d.x + d.dx)
        .innerRadius((d) -> Math.sqrt(d.y))
        .outerRadius((d) -> Math.sqrt(d.y + d.dy))

    # functions
    # main function to draw and set up the visualization using our data
    createVisualization = (json) ->

        # basic setup of page elements
        initializeBreadcrumbTrail()
        drawLegend()
        d3.select("#togglelegend").on("click", toggleLegend)

        # bounding circle underneath the sunburst, to make it easier to detect
        # when the mouse leaves the parent g
        vis.append("svg:circle")
            .attr("r", radius)
            .style("opacity", 0)

        # for efficiency, filter nodes to keep only thos large enough to see
        nodes = partition.nodes(json)
            .filter((d) -> d.dx > 0.005 )

        path = vis.data([json]).selectAll("path")
            .data(nodes)
            .enter().append("svg:path")
            .attr("display", (d) -> if d.depth then null else "none")
            .attr("d", arc)
            .attr("fill-rule", "evenodd")
            .style("fill", "red")
            .style("opacity", 1)
            .on("mouseover", mouseover)

        # add the mouseleave handler to the bounding circle
        d3.select("#container").on("mouseleave", mouseleave)

        # get total size of the tree = value of root node from partition
        totalSize = path.node().__data__.value

        return

    # fade all but the current sequence, and show it in the breadcrumb trail
    mouseover = (d) ->
        percentage = (100 * d.value / totalSize).toPrecision(3)
        percentageString = percentage + "%"
        if (percentage < 0.1)
            percentageString = "< 0.1%"

        d3.select("#percentage")
            .text(percentageString)

        d3.select("#children_name")
            .text(formatName(d.name))

        d3.select("#explanation")
            .style("visibility", "")

        sequenceArray = getAncestors(d)
        updateBreadcrumbs(sequenceArray, percentageString)

        # fade all the segments
        d3.selectAll("path")
            .style("opacity", 0.3)

        # then highlight only those that are an ancestor of the current segment
        vis.selectAll("path")
            .filter((node) -> sequenceArray.indexOf(node) >= 0)
            .style("opacity", 1)

        return

    # restore everything to full opacity when moving off the visualization
    mouseleave = (d) ->

        # hide the breadcrumb trail
        d3.select("#trail")
            .style("visibility", "hidden")

        # deactivate all segments during transition
        d3.selectAll("path").on("mouseover", null)

        #transion each segment to full opacity and then reactivate it
        d3.selectAll("path")
            .transition()
            .duration(1000)
            .style("end", -> 
                d3.select(this).on("mouseover", mouseover)
                return)

        d3.select("#explanation")
            .style("visibility", "hidden")

        return

    # given a node in a partition layout, return an array of all of its ancestor
    # nodes, highest first, but excluding the root
    getAncestors = (node) ->
        path = []
        current = node
        while current.parent
            path.unshift(current)
            current = current.parent
        return path

    initializeBreadcrumbTrail = ->

        # add the svg area
        trail = d3.select("#sequence").append("svg:svg")
            .attr("width", width)
            .attr("height", 50)
            .attr("id", "trail")
        #add the label at the end, for the percentage
        trail.append("svg:text")
            .attr("id", "endlabel")
            .style("fill", "#000")
        return

    # generate a string that describes the points of a breadcrumb polygon
    breadcrumbPoints = (d, i) ->
        points = []
        points.push("0,0")
        points.push(breadcrumb.b_width + ",0")
        points.push(breadcrumb.b_width + breadcrumb.b_tip_tail + "," + (breadcrumb.b_height / 2 ))
        points.push(breadcrumb.b_width + "," + breadcrumb.b_height)
        points.push("0," + breadcrumb.b_height)
        if (i > 0)
            # leftmost breadcrumb trail ; don't include 6th vertex
            points.push(breadcrumb.b_tip_tail + "," + (breadcrumb.b_height / 2))
        return points.join(" ")

    # update the breadcrumb trail to show the current sequence and percentage
    updateBreadcrumbs = (nodeArray, percentageString) ->

        # data join; key function combines name and depth (- positiion in sequence)
        g = d3.select("#trail")
            .selectAll("g")
            .data(nodeArray, (d) -> d.name + d.depth)

        # add breadcrumb and label for entering nodes
        entering = g.enter().append("svg:g")

        entering.append("svg:polygon")
            .attr("points", breadcrumbPoints)
            .style("fill", "blue")

        entering.append("svg:text")
            .attr("id", "name_trail")
            .attr("x", (breadcrumb.b_width + breadcrumb.b_tip_tail ) / 2)
            .attr("y", breadcrumb.b_height / 2)
            .attr("dy", "0.35em")
            .attr("text-anchor", "middle")
            .text((d) -> (d.name))

        # set position for entering and updating nodes
        g.attr("transform", (d, i) ->
            "translate(" + i * (breadcrumb.b_width + breadcrumb.b_spacing) + ",0)")

        # remove exiting nodes
        g.exit().remove()

        # now move and update the percentage at the end
        d3.select("#trail").select("#endlabel")
            .attr("x", (nodeArray.length + 0.5) * (breadcrumb.b_width + breadcrumb.b_spacing))
            .attr("y", breadcrumb.b_height / 2)
            .attr("dy", "0.35em")
            .attr("text-anchor", "middle")
            .text(percentageString)

        # make the breadcrumb trail visible, if it's hidden
        d3.select("#trail")
            .style("visibility", "")

        return

    drawLegend = ->
        li = {
            w: 75
            h: 30
            s: 3
            r: 3
        }

        legend = d3.select("#legend").append("svg:svg")
            .attr("width", li.w)
            .attr("height", d3.keys(colors).length * (li.h + li.s))

        g = legend.selectAll("g")
            .data(d3.entries(colors))
            .enter().append("svg:g")
            .attr("transform", (d, i) -> "translate(0," +  i * (li.h + li.s) + ")")

        g.append("svg:rect")
            .attr("rx", li.r)
            .attr("ry", li.r)
            .attr("width", li.w)
            .attr("height", li.h)
            .style("fill", (d) -> d.value)

        g.append("svg:text")
            .attr("x", li.w / 2)
            .attr("y", li.h / 2)
            .attr("dy", "0.35em")
            .attr("text-anchor", "middle")
            .style("fill", (d) -> d.key)

        return

    toggleLegend = ->
        legend = d3.select("#legend")
        if (legend.style("visibility") == "hidden")
            legend.style("visibility", "")
        else
            legend.style("visibility", "hidden")

        return

    # format name if his length is too long
    formatName = (name) ->
        if name.length < 15
            return name
        else
            i = name.length
            while i > 0
                if name.charCodeAt(i) > 64 && name.charCodeAt(i) < 91
                    name = name.substring(0, i) + "\n" + name.substring(i)
                    break
                i--
            return name


    # take a 2-column CSV and transform it into a hierarchical structure suitable
    # for a partition layout. The first column is a sequence of step names, from
    # root to leaf, separated by hyphens. The second column is a count of how 
    # often that sequence occurred.
    buildHierarchy = (csv) ->
        root = {
            "name": "root"
            "children": []
        }
        i = 0
        while i < csv.length
            sequence = csv[i][0]
            size = +csv[i][1]
            if isNaN(size)
                i++
                continue
            parts = sequence.split("-")
            currentNode = root
            j = 0
            while j < parts.length
                children = currentNode["children"]
                nodeName = parts[j]
                childNode
                if (j + 1 < parts.length)
                    foundChild = false
                    k = 0
                    while k < children.length
                        if (children[k]["name"] == nodeName)
                            childNode = children[k]
                            foundChild = true
                            break
                        k++
                    if !foundChild
                        childNode = {
                            "name": nodeName
                            "children": []
                        }
                        children.push(childNode)
                    currentNode = childNode
                else
                    childNode = {
                        "name": nodeName
                        "size": size
                    }
                    children.push(childNode)
                j++
            i++
        return root

    console.log(data)
    createVisualization(data)

    return

