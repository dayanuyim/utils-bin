#!/usr/bin/env python3

from http.server import SimpleHTTPRequestHandler, HTTPServer
from urllib.parse import unquote
import os
import sys

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000

class UploadDownloadHandler(SimpleHTTPRequestHandler):
    def do_POST(self):
        """Handle file uploads"""
        # 取得 URL 路徑（移除開頭的 /）
        file_path = unquote(self.path.lstrip("/"))
        if not file_path:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"Missing filename in URL path")
            return

        # 確保目錄存在
        dir_name = os.path.dirname(file_path)
        if dir_name:
            os.makedirs(dir_name, exist_ok=True)

        # 讀取上傳內容
        content_length = int(self.headers.get('Content-Length', 0))
        file_data = self.rfile.read(content_length)

        # 寫入檔案
        try:
            with open(file_path, "wb") as f:
                f.write(file_data)
            print(f"File uploaded: {file_path} ({len(file_data)} bytes)")

            # 回傳成功
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"File uploaded successfully")

        except Exception as e:
            print(f"Error saving file {file_path}: {e}")
            self.send_response(500)
            self.end_headers()
            self.wfile.write(b"Internal server error")

    # 允許 GET (瀏覽/下載)
    def do_GET(self):
        super().do_GET()


if __name__ == "__main__":
    os.chdir(os.getcwd())  # 伺服器根目錄
    server = HTTPServer(('0.0.0.0', PORT), UploadDownloadHandler)
    print(f"Serving HTTP on port {PORT} (GET for download, POST for upload)...")
    server.serve_forever()

