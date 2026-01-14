more practice with docker app usage (its features and stuff and hands on)
docker volumes

about this code - 
from http.server import HTTPServer, BaseHTTPRequestHandler class Handler(BaseHTTPRequestHandler): def do_GET(self): self.send_response(200) self.end_headers() self.wfile.write(b"Hello from inside the container") server = HTTPServer(("0.0.0.0", 3000), Handler) print("Server listening on port 3000") server.serve_forever()

docker python slim (what os comes with this , what can i do comapred to a general os)


DOCKER SWARM 

more hands on practice with docker compose

groups in linux and this - 
sudo usermod -aG docker $USER
newgrp docker

