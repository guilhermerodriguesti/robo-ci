FROM node:11-alpine

LABEL Author="Guilherme Rodrigues"

# Default environments
ENV HUBOT_SLACK_TOKEN slack-token-here
ENV HUBOT_JENKINS_CRUMB jenkins-crumb-here
ENV HUBOT_NAME robo-ci
ENV HUBOT_OWNER Guilherme Rodrigues
ENV HUBOT_DESCRIPTION "I Robot"
ENV EXTERNAL_SCRIPTS "hubot-help"

RUN npm install -g coffeescript yo generator-hubot

# Create hubot user
RUN adduser -h /home/hubot -s /bin/sh -S hubot

USER hubot

WORKDIR /home/hubot

# Install hubot
RUN yo hubot \
    --owner="${HUBOT_OWNER}" \
    --name="${HUBOT_NAME}" \
    --description="${HUBOT_DESCRIPTION}" \
    --defaults && \
    :> ./external-scripts.json && \
    npm install hubot-slack --save

VOLUME ["/home/hubot/scripts"]

EXPOSE 8989

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
  npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
  bin/hubot -n $HUBOT_NAME --adapter slack
