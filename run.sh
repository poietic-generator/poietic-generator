#!/bin/sh


LOGFILE=/var/log/poietic-$(date +%Y_%m_%d-%Hh%Mm%S).log

echo Logs are stored in : $LOGFILE

cd `dirname $0`
#rm -f *.sqlite3
bundle exec rackup config.ru -o 0.0.0.0 -p 9393 | tee -a $LOGFILE

# For real production :
#   thin -C thin-prod.yml -R config.ru start

# For development with other constraints
#   shotgun config.ru -o 0.0.0.0 -p 9393
