$(document).ready ->

    get_data_value = (browser) ->
        i = 0
        while i < data.length
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
        $(this).css("opacity", 1)
    )

    return
