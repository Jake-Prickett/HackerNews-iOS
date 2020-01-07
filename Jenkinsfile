pipeline {

    agent any

    stages {
        stage('Install Dev Dependencies') {
            steps {
                sh "carthage update --platform iOS"
            }
        }

        stage('Test') {
            steps {
                sh "fastlane tests"
            }
        }
    }
}