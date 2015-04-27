$(document).ready ->

    data = window.calendar.data

    width = 960
    height = 136
    cellSize = 17

    day = d3.time.format("%w")
    week = d3.time.format("%U")
    percent = d3.format(".1%")
    format = d3.time.format("%d/%m/%Y")

    monthPath = (t0) ->
        t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0)
        d0 = +day(t0)
        w0 = +week(t0)
        d1 = +day(t1)
        w1 = +week(t1)
        return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize +
        "H" + w0 * cellSize + "V" + 7* cellSize+
        "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize +
        "H" + (w1 + 1) * cellSize + "V" + 0+
        "H" + (w0 + 1) * cellSize + "Z"

    color = "blue"

    svg = d3.select("body").selectAll("svg")
        .data(d3.range(2010, 2015))
      .enter().append("svg")
        .attr("width", width)
        .attr("height", height)
      .append("g")
        .attr("transform", "translate(" + ((width - cellSize * 53) / 2) + "," + (height - cellSize * 7 - 1) + ")")

    svg.append("text")
        .attr("transform", "translate(-6," + cellSize * 3.5 + ")rotate(-90)")
        .style("text-anchor", "middle")
        .text((d) -> d)

    rect = svg.selectAll(".day")
        .data((d) -> d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)))
      .enter().append("rect")
        .attr("class", "day")
        .attr("width", cellSize)
        .attr("height", cellSize)
        .attr("x", (d) -> week(d) * cellSize)
        .attr("y", (d) -> day(d) * cellSize)
        .datum(format)

    rect.append("title")
        .text((d) -> d)

    svg.selectAll(".month")
        .data((d) -> d3.time.months(new Date(d, 0, 1), new Date(d +1, 0, 1)))
      .enter().append("path")
        .attr("class", "month")
        .attr("d", monthPath)

    dataNest = d3.nest()
        .key((d) -> d.Date)
        .map(data)

    rect.filter((d) -> d in dataNest)
        .attr("class", (d) -> "day" + dataNest[d])
      .select("title")
        .text((d) -> d + ": " + percent(dataNest[d]))

    d3.select(self.frameElement).style("height", "2910")
