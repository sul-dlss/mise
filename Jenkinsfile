pipeline {
  agent any

  environment {
    SIDEKIQ_PRO_SECRET = credentials("sidekiq_pro_secret")
  }

  stages {
    stage('Capistrano Deploy') {

      when {
        allOf {
          branch 'main'
        }
      }

      steps {
        checkout scm

        sshagent (['sul-devops-team', 'sul-continuous-deployment']){
          sh '''#!/bin/bash -l
          export DEPLOY=1

          # Load RVM
          rvm use 2.7.1@mise --create
          gem install bundler
          bundle install

          # Deploy it
          bundle exec cap stage deploy
          '''
        }
      }
    }
  }
}
