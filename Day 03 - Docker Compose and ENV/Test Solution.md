# -----------------------------
# TASK 1 — SETUP
# -----------------------------

cd ~
mkdir day3-test
cd day3-test

mkdir app dep

# -----------------------------
# TASK 2 — DEP SERVICE
# -----------------------------

cd dep
nano dep.sh

#!/bin/sh

echo "DEP starting..."
sleep 8
echo "DEP READY" > /ready
echo "DEP READY"

while true
do
  sleep 5
done

chmod +x dep.sh

nano Dockerfile

FROM alpine:latest
WORKDIR /
COPY dep.sh .
CMD ["./dep.sh"]


cd ..


# -----------------------------
# TASK 3 — APP SERVICE
# -----------------------------

cd app
nano app.sh

#!/bin/sh

echo "APP started"

if [ -f /ready ]; then
  echo "DEP READY"
else
  echo "DEP NOT READY"
fi

exit 0

chmod +x app.sh

nano Dockerfile


FROM alpine:latest
WORKDIR /
COPY app.sh .
CMD ["./app.sh"]

cd ..

# -----------------------------
# TASK 4 — docker-compose.yml
# -----------------------------

nano docker-compose.yml

services:
  dep:
    build: ./dep

  app:
    build: ./app
    depends_on:
      - dep

# -----------------------------
# TASK 5 — RUN (EXPECT FAILURE)
# -----------------------------

docker-compose up --build

Expected behavior - 

APP started
DEP NOT READY
DEP READY appears later
app already exited

Stop with Ctrl+C.

# -----------------------------
# TASK 6 — FIX APP LOGIC
# -----------------------------

cd app
nano app.sh

#!/bin/sh

echo "APP started"

while [ ! -f /ready ]
do
  echo "WAITING FOR DEP..."
  sleep 2
done

echo "DEP READY"
exit 0

chmod +x app.sh

cd ..

# -----------------------------
# TASK 7 — RUN AGAIN (FIXED)
# -----------------------------

docker-compose up --build

Expected behavior

app waits
dep becomes ready
app prints DEP READY
app exits successfully

