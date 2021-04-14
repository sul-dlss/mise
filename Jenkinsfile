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
          '''
        }
      }

      post {
        success {
          sh '''#!/bin/bash -l
            curl -X POST -H 'Content-type: application/json' --data '{"text":"The deploy to stage was successful"}' $SLACK_WEBHOOK_URL
          '''
        }

        failure {
          sh '''#!/bin/bash -l
            curl -X POST -H 'Content-type: application/json' --data '{"text":"The deploy to stage was unsuccessful"}' $SLACK_WEBHOOK_URL
          '''
        }
      }
    }

    stage('Deploy on release') {

      when {
        tag "v*"
      }

      steps {
        checkout scm

        sshagent (['sul-devops-team', 'sul-continuous-deployment']){
          sh '''#!/bin/bash -l
          export DEPLOY=1
          export REVISION=$TAG_NAME

          # Load RVM
          rvm use 3.0.1@mise --create
          gem install bundler

          bundle config --global gems.contribsys.com $SIDEKIQ_PRO_SECRET
          bundle install --without production

          # Deploy it
          bundle exec cap prod deploy
          '''
        }
      }

      post {
        success {
          sh '''#!/bin/bash -l
            curl -X POST -H 'Content-type: application/json' --data '{"text":"The deploy to prod was successful"}' $SLACK_WEBHOOK_URL
          '''
        }

        failure {
          sh '''#!/bin/bash -l
            curl -X POST -H 'Content-type: application/json' --data '{"text":"The deploy to prod was unsuccessful"}' $SLACK_WEBHOOK_URL
          '''
        }
      }
    }
  }
}
