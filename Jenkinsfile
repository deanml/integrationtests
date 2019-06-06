// Establish some constants for the build
def version = "1.0.${BUILD_NUMBER}"
def LOG_LEVEL_VERB = "silly"
def DONTUSE__REGISTRY = "--registry=http://npmjs.control4.com:5984"
def NPM_CACHE = "--cache=npm-cache"
def NPM_TMP = "--tmp=npm-tmp"
def RELEASE_VERSION = "3.0.0"
def REVISION_NUMBER = "UNKNOWN"
def BUILD_VERSION = "UNKNOWN"
def BROKER_VERSION = "UNKNOWN"
def LINUX_NODE_VERSION = "6.10.3"
def remote = [:]

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    stages {

        stage('Static Analysis') {
            environment {
                scannerHome = tool 'sonarscanner'
            }
            when {
                branch 'master'
            }
            steps {
                script {
                        withSonarQubeEnv('SonarQube-Prod') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectVersion=${BUILD_NUMBER}"
                        }
                }
            }
        }

        stage('Run Tests') {
            steps {
                sh "echo hi"
            }
        }

        stage('Conditional Approval') {
            when {
                branch 'develop'
                expression {currentBuild.result == 'UNSTABLE'}
            }
            steps {
                timeout(time:2, unit:'HOURS') {
                    input message:'Do you want to approve artifacts for the OS build and upload the built artifacts?'
                }
            }
        }
    }
}
