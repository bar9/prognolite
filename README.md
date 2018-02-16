# prognolite
predicting restaurant visitors (open food hack days basel)

## prerequisites

* you will need docker

## how to run the API server
`docker run  -p 8888:8888 -p 8081:8081 -v $(pwd):/code -e PASSWORD=yoursecretpass -d smizy/scikit-learn`

This will provide a jupyter notebook on port 8888 of localhost (enter with the password "yoursecretpass")

For the (app) server to run, you need to sh into the newly created container (see docker ps)
`docker exec -ti <<container-name>> sh` (replace <<container-name>> by the name docker ps returns

then install some required packages:
`pip3 install flask flask-cors`

start the server:
`python src/server.py`

## how to run the app
just open web/index.html from your local machine (via file path access). No web server required for prototyping