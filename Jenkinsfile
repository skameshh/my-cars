pipeline {
    agent any

    environment {
        SONARQUBE_URL = "http://sonarqube.local:9000"
        SONARQUBE_TOKEN = credentials('sonarqube-token') // Stored in Jenkins credentials
        ZAP_DOCKER_IMAGE = "owasp/zap2docker-stable"
    }

    stages {

        // 🎯 Stage 1: Checkout Code
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/my-cars'
            }
        }

        // 🎯 Stage 2: Run GitSecrets
        stage('GitSecrets Scan') {
            steps {
                sh 'git secrets --scan'
            }
        }

        // 🎯 Stage 3: SonarQube Code Analysis
        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=your-project -Dsonar.host.url=$SONARQUBE_URL -Dsonar.login=$SONARQUBE_TOKEN'
                }
            }
        }

        // 🎯 Stage 4: OWASP Dependency Check (SCA)
        stage('Dependency Check') {
            steps {
                sh 'dependency-check.sh --project "your-project" --scan ./ --format HTML --out reports/'
            }
        }

        // 🎯 Stage 5: OWASP ZAP Scan (DAST)
        stage('OWASP ZAP Scan') {
            steps {
                sh '''
                    docker run --rm -v $(pwd):/zap/wrk/:rw $ZAP_DOCKER_IMAGE zap-baseline.py -t https://your-app.com -r zap_report.html
                '''
            }
        }

        // 🎯 Stage 6: Publish Reports
        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/*.html', fingerprint: true
            }
        }

    }

    post {
        success {
            echo '✅ Security Scans Completed Successfully!'
        }
        failure {
            echo '❌ Security Scan Failed! Please check logs.'
        }
    }
}

