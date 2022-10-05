#!/usr/bin/env groovy

def repoURL = 'https://github.com/msoo248/simple-network-topo.git'

pipeline {
    agent {label 'ubuntu'}

    stages {
        stage('Bringup') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform plan -var-file="terraform.tfvars" -out current_plan.tfplan
                terraform apply "current_plan.tfplan"
                terraform output > output.txt
                cd ..
                array=$(grep '"*"' terraform/output.txt | sed 's/[,"]//g')
                for host in ${array[@]}; do
                echo  "$host"
                done > ansible/host-dev
                ansible-playbook -i host-dev Package.yml

                # terraform apply -destroy -auto-approve
                '''
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