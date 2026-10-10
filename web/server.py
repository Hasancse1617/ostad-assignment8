from http.server import BaseHTTPRequestHandler, HTTPServer
import os

INSTANCE_NAME = os.environ.get('INSTANCE_NAME', 'Unknown Instance')

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b"OK")
        else:
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = f"<html><body><h1>{INSTANCE_NAME}</h1></body></html>"
            self.wfile.write(html.encode('utf-8'))

    def log_message(self, format, *args):
        # Let's log to stdout
        print("%s - - [%s] %s" %
              (self.client_address[0],
               self.log_date_time_string(),
               format%args))

if __name__ == '__main__':
    server_address = ('', 80)
    httpd = HTTPServer(server_address, SimpleHandler)
    print(f"Starting {INSTANCE_NAME} on port 80...")
    httpd.serve_forever()
