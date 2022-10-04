#!/usr/bin/env groovy

def repoURL = 'https://github.com/msoo248/simple-network-topo.git'

pipeline {
    agent any

    stages {
        stage('Bringup') {
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