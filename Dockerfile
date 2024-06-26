# Use an official Node.js runtime as a parent image
FROM node:20

# Build arguments for SSH keys
ARG ssh_prv_key
ARG ssh_pub_key

# Set the working directory
WORKDIR /workspace

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install the dependencies
RUN npm install

# Install OpenSSH client and Git
RUN apt-get update && \
    apt-get install -y openssh-client git && \
    rm -rf /var/lib/apt/lists/*

# Authorize SSH Host by adding GitHub's SSH key fingerprint
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 644 /root/.ssh/id_rsa.pub

# Copy the rest of the application code
COPY . .

# Perform any git operations if needed
# Example: Cloning a repository (if needed)
# RUN git clone git@github.com:YourOrg/YourRepo.git

# Remove SSH keys
# RUN rm -rf /root/.ssh/

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
CMD ["npm", "run", "dev"]