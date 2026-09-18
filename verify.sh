#!/usr/bin/env bash
# Preflight check for the LIKE MAGIC hiring exercise.
# Run this the day you RECEIVE the repo, not the day you start work:
# the first build downloads a few hundred MB and you should not spend
# your timebox on that.
#
#   ./verify.sh
#
set -uo pipefail

PASS=0; FAIL=0
ok()   { printf "  \033[32mPASS\033[0m  %s\n" "$1"; PASS=$((PASS+1)); }
bad()  { printf "  \033[31mFAIL\033[0m  %s\n" "$1"; printf "        -> %s\n" "$2"; FAIL=$((FAIL+1)); }
info() { printf "\n\033[1m%s\033[0m\n" "$1"; }

info "1. Tooling"

if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then ok "Docker is installed and running"
  else bad "Docker is installed but not running" "Start Docker Desktop, then re-run this script."; fi
else
  bad "Docker not found" "Install Docker Desktop: https://docs.docker.com/get-docker/"
fi

if command -v java >/dev/null 2>&1; then
  JV=$(java -version 2>&1 | head -1 | grep -oE '[0-9]+' | head -1)
  if [ "${JV:-0}" -ge 25 ]; then ok "Java $JV (25 required)"
  else bad "Java $JV is too old" "This project needs Java 25. e.g. via sdkman: sdk install java 25-tem"; fi
else
  bad "Java not found" "Install a JDK 25, e.g. via sdkman: sdk install java 25-tem"
fi

if command -v node >/dev/null 2>&1; then
  NV=$(node -v | tr -d 'v' | cut -d. -f1)
  if [ "${NV:-0}" -ge 20 ]; then ok "Node $(node -v) (20+ required)"
  else bad "Node $(node -v) is too old" "This project needs Node 20 or newer."; fi
else
  bad "Node not found" "Install Node 20+: https://nodejs.org"
fi

info "2. Ports"
port_busy() {
  if command -v lsof >/dev/null 2>&1; then lsof -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
  elif command -v ss >/dev/null 2>&1; then ss -ltn 2>/dev/null | grep -q ":$1 "
  else return 1; fi
}
for p in 55432 8080 5173; do
  if port_busy "$p"; then
    if [ "$p" = "55432" ] && docker ps --format '{{.Names}}' 2>/dev/null | grep -q magic-exercise-db; then
      ok "Port $p in use by our own database container"
    else
      bad "Port $p is already in use" "Stop whatever is on port $p, or change it in docker-compose.yml / vite.config.ts."
    fi
  else
    ok "Port $p is free"
  fi
done

info "3. Database"
if docker compose ps --status running 2>/dev/null | grep -q magic-exercise-db; then
  ok "Database container is running"
else
  printf "  ....  starting database (docker compose up -d)\n"
  if docker compose up -d >/dev/null 2>&1; then
    printf "  ....  waiting for healthcheck\n"
    for _ in $(seq 1 30); do
      STATUS=$(docker inspect -f '{{.State.Health.Status}}' magic-exercise-db 2>/dev/null || echo starting)
      [ "$STATUS" = "healthy" ] && break
      sleep 2
    done
    if [ "${STATUS:-}" = "healthy" ]; then ok "Database started and healthy"
    else bad "Database did not become healthy" "Check logs: docker compose logs db"; fi
  else
    bad "docker compose up failed" "Run 'docker compose up' without -d to see the error."
  fi
fi

info "4. Backend"
printf "  ....  building (first run downloads dependencies, be patient)\n"
if (cd backend && ./mvnw -q -B -DskipTests compile >/tmp/magic-build.log 2>&1); then
  ok "Backend compiles"
else
  bad "Backend build failed" "See /tmp/magic-build.log. If ./mvnw is missing, see the README."
fi

info "5. Frontend"
if [ -d frontend/node_modules ]; then
  ok "Frontend dependencies installed"
else
  printf "  ....  installing frontend dependencies\n"
  if (cd frontend && npm install >/tmp/magic-npm.log 2>&1); then ok "Frontend dependencies installed"
  else bad "npm install failed" "See /tmp/magic-npm.log"; fi
fi

info "Result"
printf "  %s passed, %s failed\n\n" "$PASS" "$FAIL"
if [ "$FAIL" -eq 0 ]; then
  cat <<'MSG'
  You are ready. To run the app:

    Terminal 1:  cd backend  && ./mvnw spring-boot:run
    Terminal 2:  cd frontend && npm run dev

    App:      http://localhost:5173
    GraphiQL: http://localhost:8080/graphiql

MSG
  exit 0
else
  printf "  Something above needs fixing. If you believe the repo itself is broken\n"
  printf "  rather than your machine, tell us straight away. That is our bug, not yours,\n"
  printf "  and we do not want it eating into your time.\n\n"
  exit 1
fi
