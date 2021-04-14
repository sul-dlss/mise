pipeline {
  agent any

  environment {
    SIDEKIQ_PRO_SECRET = credentials("sidekiq_pro_secret")
    SLACK_WEBHOOK_URL = credentials("access_slack_webhook")
  }

  stages {
    stage('Capistrano Deploy') {

      when {
        branch 'main'
      }

      steps {
        checkout scm

        sshagent (['sul-devops-team', 'sul-continuous-deployment']){
          sh '''#!/bin/bash -l
          export DEPLOY=1

          # Load RVM
          rvm use 3.0.1@mise --create
          gem install bundler

          bundle config --global gems.contribsys.com $SIDEKIQ_PRO_SECRET
          bundle install --without production

          # Deploy it
          bundle exec cap stage deploy
          deploy_exit_code=$?

          if [ $deploy_exit_code = 0 ]; then
            deploystatus="The deploy to stage was successful"
          else
            deploystatus="The deploy to stage was unsuccessful"
          fi
          curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$deploystatus"'"}' $SLACK_WEBHOOK_URL

          exit $deploy_exit_code
          '''
        }
      }
    }
  }
}
