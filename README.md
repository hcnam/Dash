# Dash
Dankook Univ. Dept. Software Engineering  
2019-2 Capstone Design Project  

Supply Chain with Hyperledger Fabric 1.4.3  

## Test  
first test fabric end to end before start.
> ./e2e_test.sh

if there are no errors start node server and fabric nodes docker contaniers.

## Start
start fabric with  
> ./init.sh  
> ./start.sh  

start node with  
> node ./node-server/app.js  

## stop  
stop and remove all container with  
> ./stop.sh

## IMPORTANT!!!
> This project is not supporting REST api for node yet!!!!!
