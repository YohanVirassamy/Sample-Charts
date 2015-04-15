$(document).ready ->

    data = simple_bar_chart.browser

    get_data_letter = (letter) ->
        return letter


    get_data_value = (letter) ->
        i = 0
        while i < data.length
            if data[i].name == letter
                data_value = data[i].value_boy + data[i].value_girl
                break
            else
                i++
        return data_value


    get_data_boy = (letter) ->
        i = 0
        while i < data.length
            if data[i].name == letter
                data_boy = data[i].best_boy_name
                break
            else
                i++
        return data_boy


    get_data_girl = (letter) ->
        i = 0
        while i < data.length
            if data[i].name == letter
                data_girl = data[i].best_girl_name
                break
            else
                i++
        return data_girl


    $(".bar").hover( ->
        get_id_letter = $(this).attr("id")
        $(this).css("opacity", 0)
        $("#main_zone").css("opacity", 1)
        $(".info_letter").text(get_data_letter(get_id_letter))
        $(".info_value").text(get_data_value(get_id_letter))
        $(".info_boy").text(get_data_boy(get_id_letter))
        $(".info_girl").text(get_data_girl(get_id_letter))
    , ->
        $("#main_zone").css("opacity", 0)
        $(this).css("opacity", 1)
    )


