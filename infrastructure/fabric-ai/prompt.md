Let’s break down what you want:
 • You want to run the danielmiessler/Fabric project (an open-source AI prompt framework) in Docker using Docker Compose, in your own environment.
 • You want a prompt for Gemini (Google’s AI) that will generate a Docker Compose file for this purpose.
 • You want all the details needed for a working setup.

1. What Fabric Needs

From the GitHub page, Fabric is a Go application with a web interface (in the ‎⁠web⁠ directory) and a CLI. It does not provide an official Dockerfile or Compose file, but it can be built with Go and run as a binary. The web interface is a Svelte/Node app that runs with ‎⁠npm run dev⁠ (or similar).

To run Fabric in Docker Compose, you need:
 • A service for the Fabric backend (the Go binary, running with ‎⁠fabric --serve⁠)
 • A service for the web frontend (Node/Svelte, running with ‎⁠npm run dev⁠ or ‎⁠npm run build⁠ + ‎⁠npm run preview⁠)
 • Networking between the two
 • Volumes for persistent config/patterns if desired
 • Exposed ports

2. Gemini Prompt

Here is a prompt you can use with Gemini to generate a Docker Compose file for running danielmiessler/Fabric in Docker:

Prompt for Gemini:

I want to run the danielmiessler/Fabric open-source AI framework (https://github.com/danielmiessler/Fabric) in Docker using Docker Compose, in my own environment. Please generate a complete, production-ready Docker Compose file and all necessary Dockerfiles for this setup. Here are the requirements:
 • The backend should run the Fabric Go server (‎⁠fabric --serve⁠) and expose its API on port 8080.
 • The frontend should run the web interface from the ‎⁠web⁠ directory, built with Node (Svelte), and serve on port 5173 (or the default Vite port).
 • The frontend should connect to the backend API.
 • Use official base images (golang:alpine for backend, node:alpine for frontend).
 • Mount a volume for persistent Fabric config and patterns.
 • Expose both ports to the host.
 • Make sure the services are on the same Docker network.
 • Include any environment variables or build steps needed.
 • Provide all necessary details for a working setup.

Output:
 • The ‎⁠docker-compose.yml⁠ file
 • The Dockerfile for the backend
 • The Dockerfile for the frontend
 • Any extra instructions needed to build and run

3. Example Output (What Gemini Should Generate)

Here is an example of what Gemini should return (you can ask it to format like this):

docker-compose.ymlversion: "3.8"
services:
  fabric-backend:
    build: ./backend
    command: ["./fabric", "--serve", "--address=0.0.0.0:8080"]
    ports:
      - "8080:8080"
    volumes:
      - fabric_data:/root/.config/fabric
    environment:
      - FABRIC_ENV=production
    networks:
      - fabric-net

  fabric-frontend:
    build: ./web
    command: ["npm", "run", "preview", "--", "--host"]
    ports:
      - "5173:5173"
    environment:
      - VITE_API_URL=http://fabric-backend:8080
    depends_on:
      - fabric-backend
    networks:
      - fabric-net

volumes:
  fabric_data:

networks:
  fabric-net:

backend/DockerfileFROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o fabric ./cmd/fabric

FROM alpine:latest
WORKDIR /root
COPY --from=builder /app/fabric .
COPY --from=builder /app/.config/fabric ./config/fabric
EXPOSE 8080
CMD ["./fabric", "--serve", "--address=0.0.0.0:8080"]

web/DockerfileFROM node:20-alpine AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
RUN npm install -g serve
EXPOSE 5173
CMD ["serve", "-s", "dist", "-l", "5173"]

Extra Instructions
 • Place the backend Dockerfile in a ‎⁠backend/⁠ directory with the Go source.
 • Place the frontend Dockerfile in the ‎⁠web/⁠ directory.
 • Run ‎⁠docker compose up --build⁠ from the root directory.
 • Access the web UI at ‎⁠http://localhost:5173⁠.

You can copy the above prompt and example to Gemini.
If you want, I can generate the actual files for you right now—just let me know!
