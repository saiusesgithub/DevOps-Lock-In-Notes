############################################
#              BASE STAGE
############################################

# Option 1: Minimal Linux base
# FROM ubuntu:22.04

# Option 2: Alpine (smaller, faster)
# FROM alpine:3.19

# Option 3: Language specific base (RECOMMENDED)
# FROM node:20-alpine
# FROM python:3.11-slim
# FROM openjdk:17-jdk-slim

# ---- Choose one base ----
FROM node:20-alpine

############################################
#              METADATA
############################################

LABEL maintainer="yourname@email.com"
LABEL version="1.0"
LABEL description="Production-ready application image"

############################################
#          BUILD ARGUMENTS
############################################

# Build-time variables (only available during build)
ARG APP_ENV=production
ARG APP_VERSION=1.0.0

############################################
#          ENVIRONMENT VARIABLES
############################################

# Runtime environment variables
ENV NODE_ENV=$APP_ENV \
    PORT=3000 \
    TZ=UTC

############################################
#          WORKING DIRECTORY
############################################

# Creates directory if it doesn't exist
WORKDIR /app

############################################
#          COPY DEPENDENCY FILES FIRST
#    (Optimizes Docker layer caching)
############################################

COPY package*.json ./

############################################
#          INSTALL DEPENDENCIES
############################################

# For production:
RUN npm ci --only=production

# If dev needed:
# RUN npm install

############################################
#          COPY SOURCE CODE
############################################

COPY . .

############################################
#          OPTIONAL BUILD STEP
############################################

# If frontend build or TypeScript compile:
# RUN npm run build

############################################
#          CREATE NON-ROOT USER
############################################

# Improves security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to non-root user
USER appuser

############################################
#          EXPOSE PORT
############################################

# Documentation only (does NOT publish port)
EXPOSE 3000

############################################
#          HEALTHCHECK
############################################

# Checks app health every 30 seconds
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --spider -q http://localhost:3000/health || exit 1

############################################
#          ENTRYPOINT vs CMD
############################################

# Option 1: ENTRYPOINT fixed command
# ENTRYPOINT ["node"]

# Option 2: Default command (recommended)
CMD ["node", "server.js"]

############################################
#          MULTI-STAGE BUILD (OPTIONAL)
############################################

# Example structure:
#
# FROM node:20-alpine AS builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# RUN npm run build
#
# FROM nginx:alpine
# COPY --from=builder /app/dist /usr/share/nginx/html