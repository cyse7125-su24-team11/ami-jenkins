pipelineJob('Build Static Site') {
    description('Seed Pipeline Job')
    definition {
        cpsScm {
            scriptPath('./Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/static-site.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}
}
pipelineJob('CI Pipeline Helm Template') {
    description('Seed Pipeline Job')
    definition {
        cpsScm {
            scriptPath('./postgresql/continousintegration/Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/helm-webapp-cve-processor.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}
pipelineJob('CD Pipeline Helm Release') {
    description('Seed Pipeline Job')
    definition {
        cpsScm {
            scriptPath('./postgresql/continousdeployment/Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/helm-webapp-cve-processor.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}
