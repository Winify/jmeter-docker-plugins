pipeline {
    agent any
    
    options {
        buildDiscarder(logRotator(numToKeepStr: '7', daysToKeepStr: '7'))
        timestamps()
        durabilityHint('PERFORMANCE_OPTIMIZED')
    }

    stages {
        stage('ls -l') {
            steps {
              	sh 'ls -l ./tests'
            }
        }
        
        stage('JMeter-Docker Run') {
            steps {
                sh '''
                	docker run --rm \
                		--name jmeter \
                		-v /c/jenkins_home_blue/workspace/jmeter-docker/tests:/opt/tests \
                        -v /c/jenkins_home_blue/workspace/jmeter-docker/results:/opt/results \
                        jmeter-docker google
                '''
            }
        }
    }
}
