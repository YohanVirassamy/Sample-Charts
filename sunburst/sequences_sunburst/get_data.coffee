window.get_data = (query) ->
    url = "http://127.0.0.1:5000/get_engine_data"

    $.ajax(
      'url': url
      'method': 'POST'
      'data': query
    ).done (data) ->
          window.result = data
