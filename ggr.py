#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import urllib.parse as urlparse
import webbrowser as browser

search_string = sys.argv[1]
query_strings = {
        "google": "https://www.google.com/search?q=%s",
        }

def build_query(query_string, search_string):
    return query_string % (urlparse.quote(search_string))

browser.open_new_tab(build_query(query_strings["google"], search_string))
