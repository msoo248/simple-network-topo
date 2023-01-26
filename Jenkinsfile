#!/usr/bin/env groovy

pipeline {
    agent {label 'agent1'}

    stages {
        stage('Bringup') {
            steps {
                sh '''#!/bin/bash -e
                cd terraform
                terraform init
                terraform validate
                #terraform plan -var-file="terraform.tfvars" -out current_plan.tfplan
                #terraform apply "current_plan.tfplan"
                #terraform output > output.txt
                #cat output.txt
                #cd ..
                #array=$(grep '"*"' terraform/output.txt | sed 's/[,"]//g')
                #echo "[routers]" > ansible/host-dev
                #for host in ${array[@]}; do
                #  echo "$host"
                #done > ansible/host-dev
                #cat ansible/host-dev
                # cd ansible
                # ansible-playbook -i host-dev Package.yml
              
                #terraform apply -destroy -auto-approve
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
    }
}