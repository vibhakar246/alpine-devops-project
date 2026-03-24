<<<<<<< HEAD
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "start"]
=======
FROM openjdk:17-alpine

WORKDIR /app

COPY target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
>>>>>>> fe54ce8 (Clean Java DevOps project)
