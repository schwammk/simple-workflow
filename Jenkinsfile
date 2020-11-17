#!groovy
pipeline {
    agent any
    stages {
        stage('EnvSetup') {
            steps {
                script {
                    env.CLOUD_REPO = "schwammk"
                    env.VERSION = getDockerImageVersion()
                }
            }
        }
        stage('SimpleWokflow') {
            steps {
                docker build --build-arg SERVICE=SimpleWorkflow --build-arg PORT=24411 -t ${CLOUD_REPO}/simple-workflow:${VERSION} .
                docker push ${CLOUD_REPO}/simple-workflow:${VERSION}
            }
        }
        stage('StepOneWorker') {
            steps {
                docker build --build-arg SERVICE=StepOneWorker --build-arg PORT=24422 -t ${CLOUD_REPO}/step-one-worker:${VERSION} .
                docker push ${CLOUD_REPO}/step-one-worker:${VERSION}
            }
        }
        stage('StepTwoWorker') {
            steps {
                docker build --build-arg SERVICE=StepTwoWorker --build-arg PORT=24433 -t ${CLOUD_REPO}/step-two-worker:${VERSION} .
                docker push ${CLOUD_REPO}/step-two-worker:${VERSION}
            }
        }
    }
}

private String getDockerImageVersion() {
    if (env.TAG_NAME) {
        return env.TAG_NAME
    } else {
        return sh(script: 'git log --pretty=format:"%h" -n 1', returnStdout: true).trim()
    }
}
