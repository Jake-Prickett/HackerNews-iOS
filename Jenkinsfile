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
                sh "xcodebuild -scheme HackerNews -project ./HackerNews.xcodeproj -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 11,OS=13.1' build test"
            }
        }
    }
}