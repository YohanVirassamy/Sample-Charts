window.format_query_browser = (data) ->
    data_browser = {}
    data_browser["browser"] = []
    i = 0
    while i < data.data.length
        dict_sample = {}
        dict_sample["name"] = data.labels.dimensions[i]
        dict_sample["value"] = parseInt(data.data[i][0])
        data_browser.browser[data_browser.browser.length] = dict_sample
        i++
    return data_browser
