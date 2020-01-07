pipeline {

    agent any

    stages {
        stage('Install Dev Dependencies') {
            steps {
                sh "carthage update --platform iOS"
            }
        }

        stage('Shrek') {
            steps {
                sh 'xcodegen'
            }
        }

        stage('Test') {
            steps {
                sh "fastlane tests"
            }
        }
    }
}