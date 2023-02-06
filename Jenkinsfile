#!/usr/bin/env groovy

pipeline {
    agent {label 'agent1'}
    stages {
        stage('Checkout') {
            steps{
                checkout([
                    $class: 'GitSCM', branches: [[name: 'master']],
                    userRemoteConfigs: [[url: 'https://github.com/msoo248/simple-network-topo.git']]
                ])
            }
        }
        stage('Bringup') {
            steps {
                sh '''#!/bin/bash -e
                cd terraform
                terraform init
                terraform validate
                terraform plan -var-file="terraform.tfvars" -out current_plan.tfplan
                terraform apply "current_plan.tfplan"
                terraform output > output.txt
                cd ..
                python ./parser.py
                cd ansible
                ansible-playbook -i host-dev inz/eng-project.yml
                #test
                '''
                input message: 'Now, you sholud go to AWS EC2 instance, go to Networking->Change source/destination check->Stop and Save. It is a workaroud for terraform for EC2 to allow for network traffic transit', ok: 'Done'
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash -e
                DNS="$(cat quagga2_dns.txt)"
                cd ~/.ssh
                ssh -i "ansible.pem" -o "StrictHostKeyChecking=no" ubuntu@$DNS \
                "\
                rm -rf simple-network-topo;
                git clone https://github.com/msoo248/simple-network-topo.git;
                cd simple-network-topo;
                pytest test.py;
                cd ..;
                rm -rf simple-network-topo;
                \"
                '''
            }
        }
        stage('Deploy'){
            steps{
                input message: 'Do you want to deploy?', ok: 'Deploy'
                dir('terraform') {
                    sh """#!/bin/bash -e
                    echo "yes" | terraform destroy -state=/home/ec2-user/jenkins/workspace/green.tfstate
                    cp terraform.tfstate /home/ec2-user/jenkins/workspace/green.tfstate
                    """
                }
            }
        }

    }
    post {
        failure {
            dir('terraform') {
                sh "terraform apply -destroy -auto-approve"
            }
            cleanWs()
        }
        aborted{
            dir('terraform') {
                sh "terraform apply -destroy -auto-approve"
            }
            cleanWs()
        }
        success {
            cleanWs()
        }
    }
}
