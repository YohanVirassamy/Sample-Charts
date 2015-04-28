$(document).ready ->


    queries = window.queries
    url = "http://127.0.0.1:5000/get_engine_data"


    $.ajax(
      'url': url
      'method': 'POST'
      'data': {'query': JSON.stringify(queries.query_sessions_per_day)}
    ).done (data) ->

        data = format_data(data)
        max_value = d3.max(data.data_per_day, (d) -> d.value)
        first_date = data.data_per_day[0].date
        last_year = data.data_per_day[data.data_per_day.length - 1].date

        first_year = parseInt(first_date.substring(6, 10))
        last_year = parseInt(last_year.substring(6, 10)) + 1

        width = 960
        height = 136
        cellSize = 17

        day = d3.time.format("%w")
        week = d3.time.format("%U")
        percent = d3.format(".1%")
        format = d3.time.format("%d-%m-%Y")

        monthPath = (t0) ->
            t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0)
            d0 = +day(t0)
            w0 = +week(t0)
            d1 = +day(t1)
            w1 = +week(t1)
            return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize +
            "H" + w0 * cellSize + "V" + 7* cellSize +
            "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize +
            "H" + (w1 + 1) * cellSize + "V" + 0+
            "H" + (w0 + 1) * cellSize + "Z"

        svg = d3.select("body").selectAll("svg")
            .data(d3.range(first_year, last_year))
          .enter().append("svg")
            .attr("width", width)
            .attr("height", height)
          .append("g")
            .attr("transform", "translate(#{((width - cellSize * 53) / 2)}, #{(height - cellSize * 7 - 1)})")

        svg.append("text")
            .attr("transform", "translate(-6, #{cellSize * 3.5})rotate(-90)")
            .style("text-anchor", "middle")
            .text((d) -> d)

        rect = svg.selectAll(".day")
            .data((d) -> d3.time.days(new Date(d, 0, 1), new Date(d + 1, 0, 1)))
          .enter().append("rect")
            .attr("class", "day show_off")
            .attr("width", cellSize)
            .attr("height", cellSize)
            .attr("x", (d) -> week(d) * cellSize)
            .attr("y", (d) -> day(d) * cellSize)
            .datum(format)
            .attr("id", (d) -> d)
            .attr("title", (d) -> d + " : 0")


        svg.selectAll(".month")
            .data((d) -> d3.time.months(new Date(d, 0, 1), new Date(d + 1, 0, 1)))
          .enter().append("path")
            .attr("class", "month")
            .attr("d", monthPath)


        # import data
        i = 0
        while i < data.data_per_day.length

            date = data.data_per_day[i].date
            value = data.data_per_day[i].value

            id_date = "##{date}"
            data_opacity = (value / max_value) * 0.8 + 0.2

            if value == 0
                $(id_date).css("fill", "rgba(245, 83, 83, 0.2)")
            else
                $(id_date).css("fill", "rgba(54, 0, 250, #{data_opacity})")
            $(id_date).attr("title", "#{date} : #{value}")
            $(id_date).attr("class", "day show_on")
            $( document ).tooltip()
            i++
        $(".show_off").css("opacity", 0.1)
        d3.select(self.frameElement).style("height", "2910")
