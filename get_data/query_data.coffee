window.queries = {
    "query_pagePath": {
        "data": {
            "slide": {
                "date_from": "18/01/2014"
                "date_to": "18/03/2014"
                "sort": "-sessions"
            },
            "standard_dimension": "ga:pagePath"
            "metrics": [
                {
                    "name": "Visites"
                    "metric": "sessions"
                    "ga_id": "ga:71237506"
                }
            ]
        }
    }
    "query_browser": {
        "data": {
            "slide": {
                "date_from": "18/01/2014"
                "date_to": "18/03/2014"
                "sort": "-Visites"
            },
            "standard_dimension": "ga:browser"
            "metrics": [
                {
                    "name": "Visites"
                    "metric": "sessions"
                    "ga_id": "ga:71237506"
                }
            ]
        }
    }
    "query_sessions_per_day": {
        "data": {
            "slide": {
                "limit": 10000
                "date_from": "01/01/2013"
                "date_to": "17/04/2015"
            },
            "standard_dimension": "ga:date"
            "metrics": [
                {
                    "name": "Visites"
                    "metric": "sessions"
                    "ga_id": "ga:71237506"
                }
            ]
        }
    }
    "query_sessions_per_month_browser": {
        "data": {
            "slide": {
                "limit": 10000
                "date_from": "01/01/2013"
                "date_to": "31/12/2014"
            },
            "standard_dimension": "ga:yearMonth"
            "metrics": [
                {
                    "name": "Visites"
                    "metric": "sessions"
                    "ga_id": "ga:71237506"
                }
            ]
        }
    }

}
