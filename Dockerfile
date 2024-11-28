FROM imbios/bun-node:latest-20-alpine

ENV CONFIG_FILE=kilt-paseo.yml

# Install Chopsticks globally
RUN bun install -g @acala-network/chopsticks@1.0.1

# Install curl for healthcheck
RUN apk add --no-cache curl

# Set the working directory in the container
WORKDIR /app

# Copy all potential yaml configs
COPY *.yml ./
COPY *.wasm ./

# Expose port 8000 for health check
EXPOSE 8000

# Update healthcheck to use the configurable port
HEALTHCHECK --interval=10s --timeout=10s --start-period=60s --retries=6 \
  CMD curl -v http://localhost:8000 || exit 1

# Command to run Chopsticks with configurable yaml file and port
CMD chopsticks -c "$CONFIG_FILE"
