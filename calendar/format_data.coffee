window.format_date = (date) ->
    new_date = date.substring(6, 8) + "-" + date.substring(4, 6) + "-" + date.substring(0, 4)
    return new_date

window.format_data = (data) ->
    i = 0
    new_data = {}
    new_data["data_per_day"] = []
    while i < data.data.length
        dict_sample = {}
        new_date = format_date(data.labels.dimensions[i])
        dict_sample["date"] = new_date
        dict_sample["value"] = parseInt(data.data[i][0])
        new_data.data_per_day[new_data.data_per_day.length] = dict_sample
        i++
    return new_data


