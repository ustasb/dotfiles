#!/usr/bin/env bash

OFFICE_SNAKE_DIR="$HOME/projects/office_snake"

if [ ! -d $OFFICE_SNAKE_DIR ]; then
  git clone git@github.com:ustasb/office_snake.git $OFFICE_SNAKE_DIR
fi

cd $OFFICE_SNAKE_DIR && git checkout master && git pull

echo "Downloading new high scores..."

for FILE in 'classicHS.csv' 'challengeHS.csv'
do
  ssh ustasb@ustasb.com "sudo docker exec office_snake cat cgi-bin/$FILE" > $OFFICE_SNAKE_DIR/cgi-bin/$FILE
  git add cgi-bin/$FILE
done

echo "Publishing new high scores..."

git commit -m "Update highscores."
git push origin master
