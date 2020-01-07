pipeline {
    stage('Install Dev Dependencies') {
        steps {
            sh "brew install xcodegen"
            sh "brew install carthage"
            sh "brew install fastlane"
            sh "carthage update --iOS"
        }
    }

    stage('Test') {
        steps {
            sh "bundle exec fastlane tests"
        }
    }
}

