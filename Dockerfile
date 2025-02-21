# Use an Nginx base image
FROM nginx:latest

# Remove default Nginx HTML content and add our static website
RUN rm -rf /usr/share/nginx/html/*
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
