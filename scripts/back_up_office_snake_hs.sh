#!/usr/bin/env bash

# Usage: `./back_up_office_snake_hs.sh`

OFFICE_SNAKE_DIR="$HOME/projects/office_snake"

if [ ! -d $OFFICE_SNAKE_DIR ]; then
  git clone git@github.com:ustasb/office_snake.git $OFFICE_SNAKE_DIR
fi

cd $OFFICE_SNAKE_DIR && git checkout master && git pull

echo "Downloading new high scores..."

for FILE in 'classicHS.csv' 'challengeHS.csv'
do
  ssh ustasb@ustasb.com "cat ~/ustasb_com/data/office_snake/$FILE" > $OFFICE_SNAKE_DIR/public/high_scores/$FILE
  git add public/high_scores/$FILE
done

echo "Publishing new high scores..."

git commit -m "Update high scores."
git push origin master
