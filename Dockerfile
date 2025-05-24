# Use the official Bytebase image
FROM bytebase/bytebase:3.6.2

# Expose the default port
EXPOSE 8080

# Optional: specify a startup command (usually not needed as entrypoint is set)
CMD ["--port", "8080"]
