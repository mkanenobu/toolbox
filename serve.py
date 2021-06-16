#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import http.server
import socketserver
import argparse
import sys

parser = argparse.ArgumentParser(description='Simple web server.')
parser.add_argument('--port', type=int, nargs='?', help='port', default=8080)
args = parser.parse_args()

PORT = args.port

Handler = http.server.SimpleHTTPRequestHandler

try:
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print("serving at port", PORT)
        httpd.serve_forever()
except KeyboardInterrupt:
    print('KeyboardInterrupt')
    sys.exit(0)
