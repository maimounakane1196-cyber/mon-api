// Pipeline as Code : ce fichier vit dans le dépôt Git avec le code
pipeline {
    agent any

    // Jenkins vérifie GitHub toutes les minutes
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
                sh 'docker run --rm mon-api:${BUILD_NUMBER} python -c "import main"'
                sh 'echo "Test OK"'
            }
        }

                // 4. Envoyer l'image sur Docker Hub (seulement si le test a réussi)
        stage('Push') {
            steps {
                // Récupère le login/token stockés dans Jenkins, sans les écrire ici
                withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_PASS')]) {
                    // Connexion : le token passe par l'entrée standard (jamais affiché)
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    // Deuxième nom de l'image, avec le compte Docker Hub
                    sh 'docker tag mon-api:${BUILD_NUMBER} $DH_USER/mon-api:${BUILD_NUMBER}'
                    // Envoi
                    sh 'docker push $DH_USER/mon-api:${BUILD_NUMBER}'
                    // Déconnexion
                    sh 'docker logout'
                }
            }
        }

        // 4. Déployer : supprimer l'ancien conteneur, puis lancer le nouveau
        stage('Deploy') {
            steps {
                sh 'docker rm -f api-jenkins || true'
                sh 'docker run -d --name api-jenkins -p 8000:8000 mon-api:${BUILD_NUMBER}'
            }
        }
    }

    // Actions finales selon le résultat
    post {
        success {
            echo 'Pipeline reussi : application deployee.'
        }
        failure {
            echo 'Pipeline echoue : rien na ete deploye.'
        }
    }
}