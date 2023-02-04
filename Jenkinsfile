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
                terraform plan -var-file="terraform.tfvars" -out current_plan.tfplan
                terraform apply "current_plan.tfplan"
                terraform output > output.txt
                cd ..
                python ./parser.py
                cd ansible
                ansible-playbook -i host-dev inz/eng-project.yml
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''#!/bin/bash -e
                DNS="$(cat quagga2_dns.txt)"
                cd ~/.ssh
                ssh -i "ansible.pem" -o "StrictHostKeyChecking=no" ubuntu@\${dns}
                pip install -y pytest
                git clone https://github.com/msoo248/simple-network-topo.git
                cd simple-network-topo
                pytest test.py
                cd ..
                rm -rf simple-network-topo
                exit
                '''
            }
            // post{
            //     success {
            //         dir('terraform') {
            //             sh """#!/bin/bash -e
            //             terraform destroy -state=/home/ec2-user/jenkins/workspace/green.tfstate
            //             cp terraform.tfstate /home/ec2-user/jenkins/workspace/green.tfstate
            //             """
            //         }
            //     }
            //     failure {
            //         dir('terraform') {
            //             sh "terraform apply -destroy -auto-approve"
            //         }
            //     }
            // }
        }

    }
    // post {
    //     always {
    //         cleanWs()
    //     }
    // }
}
