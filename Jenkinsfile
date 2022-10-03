#!/usr/bin/env groovy

if (pullRequestdraft) {
    print "PR in draft, build SKIPPED"
    currentBuild.result = 'ABORTED'
    return
}

def repoCredentials = ''
def repoURL = 'https://github.com/msoo248/simple-network-topo.git'

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}