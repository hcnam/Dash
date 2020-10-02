# Dash
![LOGO](https://user-images.githubusercontent.com/43805697/94923731-4a01d780-04f7-11eb-96da-46a94edc8879.png)

Dankook Univ. Dept. Software Science
by. HoCheol Nam, JaeWon Park, HoJin Shin

project is about
### Supply Chain with Hyperledger Fabric 
fabric version was 1.4.3  

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

### screenshots
![example](https://user-images.githubusercontent.com/43805697/94923737-4d955e80-04f7-11eb-9ee2-bc611261ebff.png)

## stop  
stop and remove all container with  
> ./stop.sh

## IMPORTANT!!!
> This project is not supporting REST api for node yet!!!!!
