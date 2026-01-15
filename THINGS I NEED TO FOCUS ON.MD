THINGS TO FOCUS ON (PHASE 1 — DEVOPS LOCK-IN)

~~Docker Compose (highest priority) — DONE ON 15/01/26~~

- ~~Multi-service systems~~
- ~~Networking & ports~~
- ~~ENV handling~~
- ~~Break/fix practice~~

Docker Volumes
  - Persistence vs ephemerality
  - Volumes with Compose
  - Realistic data scenarios


NGINX/ FASTAPI


❌ NOT A PRIORITY (FOR NOW)

Docker Swarm ❌
Advanced Docker flags ❌
Optimizing image size ❌
Multi-stage builds ❌ (later)
Kubernetes ❌ (much later)


🚫 Docker Swarm — DROP IT

Let me be very clear:
Docker Swarm is largely obsolete
Rarely used in real-world modern setups
Almost zero demand compared to:
Docker + Compose
Kubernetes (later, not now)

Learning Swarm now gives you near-zero ROI.

---
---

more practice with docker app usage (its features and stuff and hands on)

about this code - 
from http.server import HTTPServer, BaseHTTPRequestHandler class Handler(BaseHTTPRequestHandler): def do_GET(self): self.send_response(200) self.end_headers() self.wfile.write(b"Hello from inside the container") server = HTTPServer(("0.0.0.0", 3000), Handler) print("Server listening on port 3000") server.serve_forever()

docker python slim (what os comes with this , what can i do comapred to a general os)
groups in linux and this - 
sudo usermod -aG docker $USER
newgrp docker