# Welcome to Url Shortner Demo

If you already have rails installed just bunlde install and run the server.
Otherwise you can follow instruction below to set it up with docker.
## First, build the app for development purposes
`docker-compose build`

## Create the database
`docker-compose run web scripts/wait-for-it.sh db:5432 --  "rake db:create db:migrate"`

## Run the app in development mode
`docker-compose up`

Now open http://localhost:3000 and look at your Javascript console to see messages

## Entering the web container
`docker-compose exec web bash`

## Creating a new config/master.key and config/credentials.yml.enc
You will need these 2 files for the asset pipeline for the production build.

First enter the web container as highlighed above. Then run:
`run EDITOR=vim rails credentials:edit`

exit and save via `:wq`

## Build the app for production
`docker build -t docker-rails-demo .`

Released under the  [MIT License](https://opensource.org/licenses/MIT)
