#!/usr/bin/env python3
import json
import subprocess
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse

class DDEVDashboardHandler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_POST(self):
        if self.path == '/api/ddev-list':
            try:
                result = subprocess.run(
                    ['ddev', 'list', '-j'],
                    capture_output=True,
                    text=True,
                    timeout=10
                )
                
                if result.returncode != 0:
                    self.send_error_response(500, f'DDEV command failed: {result.stderr}')
                    return
                
                output = result.stdout
                json_start = output.find('{"level"')
                if json_start == -1:
                    self.send_error_response(500, 'No JSON found in output')
                    return
                
                json_string = output[json_start:]
                json_end = json_string.rfind('}')
                if json_end == -1:
                    self.send_error_response(500, 'Invalid JSON format')
                    return
                
                json_string = json_string[:json_end + 1]
                data = json.loads(json_string)
                
                if 'raw' in data:
                    self.send_json_response({'raw': data['raw']})
                else:
                    self.send_error_response(500, 'No projects data found')
                    
            except subprocess.TimeoutExpired:
                self.send_error_response(500, 'DDEV command timeout')
            except json.JSONDecodeError as e:
                self.send_error_response(500, f'JSON decode error: {str(e)}')
            except Exception as e:
                self.send_error_response(500, f'Error: {str(e)}')
        else:
            self.send_error_response(404, 'Not found')

    def do_GET(self):
        if self.path == '/' or self.path == '/dashboard.html':
            try:
                with open('ddev-dashboard.html', 'r') as f:
                    content = f.read()
                self.send_response(200)
                self.send_header('Content-Type', 'text/html')
                self.end_headers()
                self.wfile.write(content.encode())
            except FileNotFoundError:
                self.send_error_response(404, 'Dashboard HTML not found')
        else:
            self.send_error_response(404, 'Not found')

    def send_json_response(self, data):
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def send_error_response(self, code, message):
        self.send_response(code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps({'error': message}).encode())

    def log_message(self, format, *args):
        pass

if __name__ == '__main__':
    port = 8888
    if len(sys.argv) > 1:
        port = int(sys.argv[1])
    
    server = HTTPServer(('localhost', port), DDEVDashboardHandler)
    print(f'DDEV Dashboard server running on http://localhost:{port}/')
    print('Press Ctrl+C to stop')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print('\nShutting down server...')
        server.shutdown()
