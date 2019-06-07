// Establish some constants for the build
def version = "1.0.${BUILD_NUMBER}"
def RELEASE_VERSION = "3.0.0"
def REVISION_NUMBER = "UNKNOWN"
def BUILD_VERSION = "UNKNOWN"

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Build') {
            tools {
                maven 'Maven3.6.1'
                jdk 'jdk1.9'
            }
            steps {
                sh "mvn clean compile"
            }
        }

        stage('Static Analysis') {
            environment {
                scannerHome = tool 'sonarscanner'
            }
            when {
                branch 'develop'
            }
            steps {
                script {
                        withSonarQubeEnv('SonarQube-Prod') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectVersion=${BUILD_NUMBER}"
                        }
                }
            }
        }

        stage('Unit Tests and Coverage') {
            tools {
                maven 'Maven3.6.1'
                jdk 'jdk1.9'
            }
            steps {
                sh "mvn test"
                echo 'Testing failed!'
                script { currentBuild.result = 'UNSTABLE' }
            }
        }

        stage('Create Artifact') {
            steps {
                sh "echo do the steps to create your artifacts here"

            }
        }

        stage('Publish Artifact') {
            when {
                not {
                    branch 'develop'
                }
                expression {currentBuild.result == 'UNSTABLE'}
            }
            steps {
                timeout(time:2, unit:'HOURS') {
                    input message:'Do you want to approve artifacts for the OS build and upload the built artifacts?'
                }
            }
            post {
                cleanup {
                    deleteDir()
                }
            }
        }
    }
}

