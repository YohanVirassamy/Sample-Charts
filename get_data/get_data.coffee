$(document).ready ->

    query = window.queries

    #console.log(JSON.stringify(query.query_browser, undefined, 4))
    url = "http://127.0.0.1:5000/get_engine_data"


    $.ajax(
      'url': url
      'method': 'POST'
      'data': {'query': JSON.stringify(query.query_browser)}
    ).done (data) ->

        console.log(JSON.stringify(data, undefined, 4))
        $("#jason").text(JSON.stringify(data, undefined, 4))

    return

