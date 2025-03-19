# Containerize an aplicattion with Docker

## 1.Choose an application

- I chose to containerize the python aplication because\
    I am familiar containerizing python applications.

## 2. Create a Dockerfile

- Create a Dockerfile in the root directory of the application
- Add the following lines to the Dockerfile:
  - WORKDIR /2-app -> to set the working directory
  - COPY . /2-app -> to copy the files from the current directory to the working directory
  - RUN pip install -r requirements.txt -> to install the dependencies
  - CMD ["python", "app.py"] -> to run the application
  - EXPOSE 8080 -> to expose the port 8080

## 3. Local testing

- Build the docker image by running the following command in the 2-app directory:
  - docker build -t calculator .
    - -t flag: to tag the image with the name calculator
  - docker images -> to check if the image is created
  - docker run -p 8080:8080 -d --name calculator-container calculator -> to run the container
    - -p flag: to map the port 8080 from the container to the host
    - -d flag: to run the container in the background
    - --name flag: to name the container
  - docker ps -> to check if the container is running
  - access the application by going to http://localhost:8080 in the browser

## 4. Set up a Docker Registry

- Create an account on Docker Hub
- Log in to Docker Hub using the following command:
  - docker login
  - redirect to the Docker Hub website and log in
  - return to the terminal and wait for the login confirmation
- Tag the image with your Docker Hub username and push it to the registry:
  - docker tag calculator robert2308/internship-task2-tremend:readme-test
  - docker push robert2308/internship-task2-tremend:readme-test
- check [my images](https://hub.docker.com/repository/docker/robert2308/internship-task2-tremend/tags) to see the pushed image

## 5. Automation with GitHub Actions

- from the repository, go to the Actions tab
- add a new auto-generated workflow called Docker Image
- push the changes to the repository
- pull the changes from the repository to the local machine
- modify genearated yml file to build and push the image to the Docker Hub
  - trigger on push to the main branch using on: push: branches: main and master
  - when the workflow is triggered, it will build the image, tag it, and push it to the Docker Hub
    - use docker/login-action@v3 to log in to Docker Hub
    - use docker/build-push-action@v6 to build and push the image
      - push set to true to push the image to the Docker Hub
      - tag using the repository name and the commit hash
      - file to specify the Dockerfile location
      - context to specify the build context

## Bonus

### 1. Application catches the Docker container's stop signal

- in calculator.py, a signal handler is added to catch the SIGTERM signal
- the signal handler prints a message and exits the application
- to test the signal handler, run the container and stop it using the following command:
  - docker stop calculator-container
  - check the logs to see the message printed by the signal handler

### 2. Configure environment variables for sensitive information

- for github actions, the Docker Hub username and password are stored as secrets
- the secrets are accessed in the workflow using ${{ secrets.SECRET_NAME }}
- the secrets are set in the repository settings under Secrets
