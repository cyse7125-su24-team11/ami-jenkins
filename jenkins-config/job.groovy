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
multibranchPipelineJob('CI Pipeline Helm Template') {
    description('Multibranch Pipeline Job for Helm Template CI')
    branchSources {
        git {
            id('helm-template-ci-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-webapp-cve-processor.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
            includes('*') // Include all branches
            excludes('') // Exclude no branches
        }
    }
       factory {
        workflowBranchProjectFactory {
            scriptPath('postgresql/continousintegration/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}
 
multibranchPipelineJob('CD Pipeline Helm Release') {
    description('Multibranch Pipeline Job for Helm Release CD')
    branchSources {
        git {
            id('helm-release-cd-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-webapp-cve-processor.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('postgresql/continousdeployment/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}
