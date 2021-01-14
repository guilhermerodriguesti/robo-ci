# hubot-slack-jenkins

This is an alpine based hubot image which includes jenkins plugin and slack adapter. 
The plugin is forked from [hubot-jenkins-enhanced](https://github.com/codeandfury/hubot-jenkins-enhanced)
with'a minor addition line jenkins crumb support (also, as an improvement, 
triggering jobs based on users' permission is planned.)

## Environment Variables:
In order to run a container from the image, you need to provide a bunch of variable listed below:

- **HUBOT_NAME**: Your bot name (default name is tonguc)
- **HUBOT_SLACK_TOKEN**: You need to generate a hubot slack app and get a slack token 
from [http://slackapi.github.io/hubot-slack/](http://slackapi.github.io/hubot-slack/)
- **HUBOT_JENKINS_URL**: Your jenkins url
- **HUBOT_JENKINS_AUTH**: Jenkins credentials in `username:password` format.
- **HUBOT_JENKINS_CRUMB**: If you use CSFR prevention in Jenkins (which is default) you 
need to generate it. To do this you can use a wget command like this:
 
```
    wget -q \
         --auth-no-challenge \
         --user username \
         --password password \
         --output-document - \
    'https://YOUR_JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
```
 
- **EXTERNAL_SCRIPTS**: Additional hubot plugins you want to run. 
If not provided, hubot-help plugin will be ran as default. 

## How to run

First, grab the [jenkins-enhanced.coffee](https://bitbucket.org/guilhermerodriguesti/robo-ci/src/master/scripts/jenkins-enhanced.coffee)
file and place it on a local folder (which will be binded to the container)

And run the container:

```
docker run -d \
        --name $HUBOT_NAME \
        -e HUBOT_NAME=$HUBOT_NAME \
        -e HUBOT_SLACK_TOKEN=$HUBOT_SLACK_TOKEN \
        -e HUBOT_JENKINS_URL=$HUBOT_JENKINS_URL \
        -e HUBOT_JENKINS_AUTH=$HUBOT_JENKINS_AUTH \
        -e HUBOT_JENKINS_CRUMB=$HUBOT_JENKINS_CRUMB \
        -e EXTERNAL_SCRIPTS=$EXTERNAL_SCRIPTS \
        -p 8989:8989 \
        -v $PWD/scripts:/home/hubot/scripts \
        ${REPO_IMAGES}/${IMAGE_NAME}:${TAG}
```