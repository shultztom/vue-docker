#!/usr/bin/env groovy

node('linux'){
    // Not using yarn commands as Node is not present

    // Clean Up (Docker and Workspace)
    stage('Clean Up') {
        sh "docker system prune -a -f"
        
        try {
            sh "rm -rf *"
        } catch (Exception e) {}
        try {
            sh "rm .env .gitignore .npmrc .nvmrc"
        } catch (Exception e) {}
        try {
            sh "rm -rf .git"
        } catch (Exception e) {}
    }

    // Checkout code
    stage('Checkout') {
        echo 'Pulling Branch: ' + env.BRANCH_NAME
        checkout scm
    }

    // Build Image
    stage('Build') {
        sh "./scripts/build.sh"
    }

    // Docker Login
    stage('Docker Login') {
        withCredentials([usernamePassword(credentialsId: 'docker-username-password', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            sh "docker login --username=${USERNAME} --password=${PASSWORD}"
        }
    }

    // Push Image
    stage('Push') {
        sh "./scripts/push.sh"
    }


    //  Add OC CLI
    stage('Add OC CLI') {
        def dir = pwd()
        sh "cp ~/jenkins/tools/oc-cli/oc ${dir}/"
        sh "./oc"
    }
    
    // OC Login
    stage('OC Login') {
        withCredentials([usernamePassword(credentialsId: 'oc-cli-mini', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
            sh "./oc login https://192.168.1.45:8443 -u ${USER} -p ${PASS} --insecure-skip-tls-verify"
        }
    }

    // OC Project
    stage('OC Project Build') {
        sh "./oc project vue-docker"
    }

    // OC Import Image
    stage('OC Import Image') {
        sh "./oc import-image node-app"
    }
    
    // OC Logout
    stage('OC Logout') { 
        sh "./oc logout"
    }

    // Docker Logout
    stage('Docker Logout') {
        sh "docker logout"
    }

    // Clean Up (Docker and Workspace)
    stage('Clean Up') {
        sh "docker system prune -a -f"

        try {
            sh "rm -rf *"
        } catch (Exception e) {}
        try {
            sh "rm .env .gitignore .npmrc .nvmrc"
        } catch (Exception e) {}
        try {
            sh "rm -rf .git"
        } catch (Exception e) {}
    }

}