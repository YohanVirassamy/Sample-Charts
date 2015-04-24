$(document).ready ->

    queries = window.queries
    url = "http://127.0.0.1:5000/get_engine_data"


    $.ajax(
      'url': url
      'method': 'POST'
      'data': {'query': JSON.stringify(queries.query_browser)}
    ).done (data) ->


        console.log JSON.stringify(data)
        data = format_query_browser(data)
        console.log data.browser
        console.log d3.max(data.browser, (d) -> d.value)

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
            .domain([0, d3.max(data.browser, (d) -> d.value)])

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
            .text("Visits per browser")

        bar = svg.selectAll(".bar")
            .data(data.browser)
          .enter()

        #draws bar
        bar.append("rect")
            .attr("id", (d) -> d.name)
            .attr("class", "bar")
            .attr("x", (d) -> x(d.name))
            .attr("width", x.rangeBand())
            .attr("y", (d) -> y(d.value))
            .attr("height", (d) -> height - y(d.value))


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

        text_browser = info.append("text")
            .attr("class", "info_browser")
            .attr("x", width_info / 3)
            .attr("y", height_info / 4)
            .attr("fill", "black")
            .attr("font-size", "20px")
            .text("")

        text_value = info.append("text")
            .attr("class", "info_value")
            .attr("x", width_info / 10)
            .attr("y", height_info / 2.4)
            .attr("fill", "black")
            .attr("font-size", "30px")
            .text("")

        get_data_value = (browser) ->
                i = 0
                while i < data.browser.length
                    if data.browser[i].name == browser
                        data_value = data.browser[i].value
                        break
                    else
                        i++
                return data_value

        $(".bar").hover( ->
            get_browser = $(this).attr("id")
            $(this).css("fill", "red")
            $("#main_zone").css("opacity", 1)
            $(".info_browser").text(get_browser)
            $(".info_value").text(get_data_value(get_browser))
        , ->
            $("#main_zone").css("opacity", 0)
            $(this).css("fill", "#349AED")
        )

