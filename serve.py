#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import http.server
import socketserver
import argparse
import sys

parser = argparse.ArgumentParser(description='Simple web server.')
parser.add_argument('--port', type=int, nargs='?', help='port', default=8080)
parser.add_argument('--host', type=str, nargs='?', help='host', default='')
args = parser.parse_args()

PORT = args.port
HOST = args.host

Handler = http.server.SimpleHTTPRequestHandler

for attempt in range(5):
    try:
        with socketserver.TCPServer((HOST, PORT), Handler) as httpd:
            h = httpd.socket.getsockname()[0]
            host = 'localhost' if h == '0.0.0.0' else h
            print(f'serving at http://{host}:{PORT}')
            httpd.serve_forever()
    except OSError as e:
        if e.errno == 48:
            print(f'Port {PORT} in use, trying port {PORT + 1}')
            PORT += 1
            continue
        else:
            raise e
    except KeyboardInterrupt:
        print('KeyboardInterrupt')
        sys.exit(0)
    else:
        break
