echo -n "gitlab user:"
read GIT_USER
echo -n "gitlab password:"
read GIT_PASSWORD
git clone https://$GIT_USER:$GIT_PASSWORD@gitlab.com/neo_duelbot/neo_duelbot2 scripts
