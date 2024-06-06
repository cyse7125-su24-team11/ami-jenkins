pipelineJob('seed') {
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