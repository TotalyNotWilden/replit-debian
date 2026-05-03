FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN echo "Alive" > index.html
EXPOSE 10000
CMD ["python3", "-m", "http.server", "10000"]
