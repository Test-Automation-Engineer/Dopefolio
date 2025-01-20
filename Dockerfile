# Use the official Node.js image as the base image
FROM node:14 as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run compress:css

# stage 4 - build the final image and copy the react build files
FROM nginxinc/nginx-unprivileged:1.27-alpine as release

COPY --chown=1000:1000 --from=build /app /usr/share/nginx/html

USER 1000

EXPOSE 8080