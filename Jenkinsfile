#!groovy
pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    triggers {
        githubPush()
    }

    stages {
        stage('Docker login') {
            steps {
                script {
                    env.PROJECT_NAME = 'xxxl-services'
                    env.GCR = "eu.gcr.io/${env.PROJECT_NAME}/stocklevel"
                    env.VERSION = getDockerImageVersion()
                }
                container('docker') {
                    withCredentials([file(credentialsId: 'gcr-kyma-xxxlservices', variable: 'keyfile')]) {
                        sh "cat ${keyfile} | docker login -u _json_key --password-stdin https://eu.gcr.io/${PROJECT_NAME}"
                    }
                }
            }
        }
        stage('ClickstreamPublishing') {
            steps {
                container('docker') {
                    sh "docker build --build-arg SERVICE=ClickstreamPublishing --build-arg PORT=10481 -t ${GCR}/stocklevel-clickstreampublishing-service:${VERSION} ."
                    sh "docker push ${GCR}/stocklevel-clickstreampublishing-service:${VERSION}"
                }
            }
        }
        stage('StockEventCollector') {
            steps {
                container('docker') {
                    sh "docker build --build-arg SERVICE=StockEventCollector --build-arg PORT=10480 -t ${GCR}/stocklevel-eventcollector-service:${VERSION} ."
                    sh "docker push ${GCR}/stocklevel-eventcollector-service:${VERSION}"
                }
            }
        }
        stage('StockFetcher') {
            steps {
                container('docker') {
                    sh "docker build --build-arg SERVICE=StockFetcher --build-arg PORT=10482 -t ${GCR}/stocklevel-stockfetcher-service:${VERSION} ."
                    sh "docker push ${GCR}/stocklevel-stockfetcher-service:${VERSION}"
                }
            }
        }
        stage('StockLevelCacheManager') {
            steps {
                container('docker') {
                    sh "docker build --build-arg SERVICE=StockLevelCacheManager --build-arg PORT=10483 -t ${GCR}/stocklevel-cachemanager-service:${VERSION} ."
                    sh "docker push ${GCR}/stocklevel-cachemanager-service:${VERSION}"
                }
            }
        }
        stage('StockLevelCacheConnector') {
            steps {
                container('docker') {
                    sh "docker build --build-arg SERVICE=StockLevelCacheConnector --build-arg PORT=10485 -t ${GCR}/stocklevel-cacheconnector-service:${VERSION} ."
                    sh "docker push ${GCR}/stocklevel-cacheconnector-service:${VERSION}"
                }
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
