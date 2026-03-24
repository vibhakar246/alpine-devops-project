<<<<<<< HEAD
# Dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Expose port
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
=======
FROM openjdk:17-alpine

WORKDIR /app

COPY target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
>>>>>>> fe54ce8 (Clean Java DevOps project)
