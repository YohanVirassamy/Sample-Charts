$(document).ready ->

    data = simple_bar_chart

    top = 20
    right = 20
    bottom = 30
    left = 40

    width = 1100 - left - right
    height = 500 - top - bottom
    width_info = 300
    height_info = 400

    #builds domains
    x =  d3.scale.ordinal()
        .domain(data.browser.map((d) -> d.name))
        .rangeRoundBands([0, width], 0.1)

    y = d3.scale.linear()
        .range([height, 0])
        .domain([0, d3.max(data.browser, (d) -> (d.value_boy + d.value_girl))])

    #buils axes
    xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom")

    yAxis = d3.svg.axis()
        .scale(y)
        .orient("left")

    #builds chart
    svg = d3.select("#datavis")
        .append("svg")
            .attr("width", width + left + right)
            .attr("height", height + top + bottom)
        .append("g")
            .attr("transform", "translate(" + left + "," + top + ")")


    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)


    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
      .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", "0.71em")
        .style("text-anchor" , "end")
        .text(data.site)

    bar = svg.selectAll(".bar")
        .data(data.browser)
      .enter()

    #draws bar for separate values ( boy /girl )
    bar.append("rect")
        .attr("id", (d) -> d.name)
        .attr("class", "bar_boy")
        .attr("x", (d) -> x(d.name))
        .attr("width", x.rangeBand())
        .attr("y", (d) -> y(d.value_boy))
        .attr("height", (d) -> height - y(d.value_boy))

    bar.append("rect")
        .attr("id", (d) -> d.name)
        .attr("class", "bar_girl")
        .attr("x", (d) -> x(d.name))
        .attr("width", x.rangeBand())
        .attr("y", (d) -> y(d.value_girl + d.value_boy))
        .attr("height", (d) -> height - y(d.value_girl))

    #draws bars for total value
    bar.append("rect")
        .attr("id", (d) -> d.name)
        .attr("class", "bar")
        .attr("x", (d) -> x(d.name))
        .attr("width", x.rangeBand())
        .attr("y", (d) -> y(d.value_boy + d.value_girl))
        .attr("height", (d) -> height - y(d.value_boy + d.value_girl))

    #builds info chart
    info = d3.select("#datavis")
        .append("svg")
            .attr("width" , width_info)
            .attr("height", height_info)
            .attr("id", "main_zone")

    area = info.append("rect")
        .attr("class", "area_letter")
        .attr("width", width_info)
        .attr("height", height_info - bottom)
        .attr("stroke", "black")
        .attr("fill", "white")

    text_letter = info.append("text")
        .attr("class", "info_letter")
        .attr("x", width_info / 3)
        .attr("y", height_info / 4)
        .attr("fill", "black")
        .attr("font-size", "100px")
        .text("")

    text_value = info.append("text")
        .attr("class", "info_value")
        .attr("x", width_info / 10)
        .attr("y", height_info / 2.4)
        .attr("fill", "black")
        .attr("font-size", "30px")
        .text("")

    text_boy = info.append("text")
        .attr("class", "info_boy")
        .attr("x", width_info / 10)
        .attr("y", height_info / 1.6)
        .attr("fill", "black")
        .attr("font-size", "30px")
        .text("")

    text_girl = info.append("text")
        .attr("class", "info_girl")
        .attr("x", width_info / 10)
        .attr("y", height_info / 1.2)
        .attr("fill", "black")
        .attr("font-size", "30px")
        .text("")
