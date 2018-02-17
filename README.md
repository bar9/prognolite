Restaurants face a big problem, that they don't know how many guests are coming the next day or next week. This leads to different problems like: 

- Foodwaste

- high personnel costs 

- unhappy customers

Our team tried to solve this problem by forecasting the amount of people for noon and evening for a restaurant located in Zürich. This forecasts are afterwards displayed in an App for the kichen chef and the chef de service. 

We took data from a reservation system as our brain how the demand was in the past. Together with influencing factors like holidays, weekdays, seasonality we calculated our forecasts. The output of those forecasts is being written in the API of Prognolite. The App, that we developed with an experienced designer connects to the Prognolite API calls the forecasts, weather icons and holidays and visualizes it. We found out that the predictions for the evening are much better than for noon and found the reason in employees who don't register all the walk-ins. 

Team members: 
- <a href="https://www.linkedin.com/in/roland-brand-95a28b108/">Roland Brand</a> 
- <a href="https://www.linkedin.com/in/claudia-c-fricker-3b273685/">Claudia Fricker</a> 
- <a href="https://www.linkedin.com/in/eugene-orlov-4aa91a9b/">Eugene Orlov</a> 
- <a href="https://www.linkedin.com/in/olga-matveeva-203b9a67/">Olga Matveeva</a> 
- <a href="https://www.linkedin.com/in/ewaguminska/">Ewa Guminska</a> 
- <a href="https://www.linkedin.com/in/esoguel/">Etienne Soguel-dit-Piquard</a> 
- <a href="https://www.linkedin.com/in/romanlickel/">Roman Lickel</a> 
- <a href="https://www.linkedin.com/in/simon-michel/">Simon Michel</a> 

Our App: 

<img src="https://prognolite.com/site/wp-content/uploads/2018/02/Bildschirmfoto-2018-02-17-um-15.05.35.png" width="300">


Presentation: 

https://prezi.com/p/xyoae-scgimn/
























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
