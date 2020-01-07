pipeline {

    parameters {
        choice(choices: ['Development', 'Staging', 'Production'], description: 'Choose the environment you want to build', name: 'environment')
    }

    environment {
        tagDate = sh(returnStdout: true, script: "date  \"+%m-%d-%y_%H-%M-%p\"").trim()
        gitTag = "alpha-success_${tagDate}"
        shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    }

    agent {
        label 'MacOS'
    }

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }

    stages {
        stage('Setup xcodeproj') {
            steps {
               sh '''
                    osascript -e 'quit app "Simulator"'
                    ps aux | grep _sim | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null
                    killall -9 com.apple.CoreSimulator.CoreSimulatorService
                    rm -rf ~/Library/Developer/Xcode/DerivedData/*
                    pod install --repo-update
                '''
            }
        }

        stage('Install Dev Dependencies') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
           steps {
              sh "bundle exec fastlane tests"
           }
       }

        stage('Build') {
            steps {
                script {
                    if (env.environment == 'Production') {
                        sh "bundle exec fastlane prod"
                        sh "bundle exec fastlane incrementVersionNumber branch:${env.BRANCH_NAME} bumpType:'minor' tag:'prod_success_${tagDate}'"
                        archiveArtifacts artifacts: 'RHF-Driver-App.ipa'
                     } else if (env.environment == 'Staging') {
                        sh "bundle exec fastlane staging"
                        sh "bundle exec fastlane incrementVersionNumber branch:${env.BRANCH_NAME} bumpType:'patch' tag:'staging_success_${tagDate}'"
                        archiveArtifacts artifacts: 'RHF-Driver-App.ipa'
                     }
                }
            }
        }

        stage('Deploy app') {
            when {
                anyOf {
                    environment name: 'environment', value: 'Staging'
                    environment name: 'environment', value: 'Production'
                }
            }
            steps {
                script {
                    if (environment == "Staging") {
                        withCredentials([string(credentialsId: 'app-center-api-token', variable: 'API_TOKEN')]) {
                            sh '''
                                UPLOAD_RESPONSE=$(curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/DriverAppStage/release_uploads")
                                UPLOAD_ID=$(echo $UPLOAD_RESPONSE | jq -r '.upload_id')
                                UPLOAD_URL=$(echo $UPLOAD_RESPONSE | jq -r '.upload_url')
                                curl -F "ipa=@RHF-Driver-App.ipa" $UPLOAD_URL
                                RELEASE_ID=$(curl -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" -d '{ "status": "committed"  }' "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/DriverAppStage/release_uploads/$UPLOAD_ID" | jq -r '.release_id')
                                curl -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" -d '{ "distribution_group_name": "Collaborators" }' "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/DriverAppStage/releases/$RELEASE_ID"
                            '''
                        }
                    } else if (environment == "Production") {
                        withCredentials([string(credentialsId: 'app-center-api-token', variable: 'API_TOKEN')]) {
                            sh '''
                                UPLOAD_RESPONSE=$(curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/com.ford.RHF.DriverApp/release_uploads")
                                UPLOAD_ID=$(echo $UPLOAD_RESPONSE | jq -r '.upload_id')
                                UPLOAD_URL=$(echo $UPLOAD_RESPONSE | jq -r '.upload_url')
                                curl -F "ipa=@RHF-Driver-App.ipa" $UPLOAD_URL
                                RELEASE_ID=$(curl -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" -d '{ "status": "committed"  }' "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/com.ford.RHF.DriverApp/release_uploads/$UPLOAD_ID" | jq -r '.release_id')
                                curl -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' --header "X-API-Token: $API_TOKEN" -d '{ "distribution_group_name": "Collaborators" }' "https://api.appcenter.ms/v0.1/apps/dev-dev-central-station/com.ford.RHF.DriverApp/releases/$RELEASE_ID"
                            '''
                        }
                    }
                }
            }
        }
    }
}

