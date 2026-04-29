from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import time

PORT = 8080

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        files = os.listdir("/data")
        response = "\n".join(files)

        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(response.encode())

def run():
    server = HTTPServer(("", PORT), Handler)
    print(f"Server running on {PORT}")
    server.serve_forever()

if __name__ == "__main__":
    run()