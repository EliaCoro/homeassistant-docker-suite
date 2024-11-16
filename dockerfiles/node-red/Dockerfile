# Use the official Node-RED image as the base image
FROM nodered/node-red-docker:v8

WORKDIR /usr/src/node-red

# Install the node-red-contrib-home-assistant package
RUN cd /data
RUN npm install node-red-contrib-home-assistant

# Start Node-RED with the specified user directory
CMD ["npm", "start", "--", "--userDir", "/data"]
