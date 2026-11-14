// Pipeline as Code : ce fichier vit dans le dépôt Git, avec le code
pipeline {
    agent any

    // Déclencheur : Jenkins vérifie GitHub toutes les minutes
    // et lance le pipeline s'il y a un nouveau commit
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        // 1. Récupérer le code du dépôt qui contient ce Jenkinsfile
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        // 2. Construire l'image, versionnée avec le numéro du build
        stage('Build') {
            steps {
                sh 'docker build -t mon-api:${BUILD_NUMBER} .'
            }
        }

        // 3. Tester : main.py doit se charger sans erreur
        stage('Test') {
            steps {
                sh 'docker run --rm mon-api:${BUILD_NUMBER} python -c "import main; print(\'Test OK\')"'
            }
        }

        // 4. Déployer : remplacer l'ancien conteneur par le nouveau
        stage('Deploy') {
            steps {
                sh 'docker rm -f api-jenkins || true'
                sh 'docker run -d --name api-jenkins -p 8000:8000 mon-api:${BUILD_NUMBER}'
            }
        }
    }

    // Actions finales, exécutées selon le résultat
    post {
        success {
            echo 'Pipeline réussi : application déployée.'
        }
        failure {
            echo 'Pipeline échoué : rien n\'a été déployé.'
        }
    }
}