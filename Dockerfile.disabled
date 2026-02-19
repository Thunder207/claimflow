# Government Expense Tracker - Production Docker Image
# Optimized for Railway, Heroku, and other cloud platforms

FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S appuser -u 1001

# Install dependencies in a cached layer
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY . .

# Create required directories with proper permissions
RUN mkdir -p uploads logs exports && \
    chown -R appuser:nodejs uploads logs exports

# Remove development files for smaller image
RUN rm -rf test-*.js debug-*.js qa-agent.js

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:3000/api/health/system || exit 1

# Start the application
CMD ["node", "app.js"]