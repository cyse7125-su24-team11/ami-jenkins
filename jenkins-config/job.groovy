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


//                                                                      //
//---------------------------AWS Infrastructure-------------------------//
//                                                                      //


pipelineJob('CI Terraform Infra AWS') {
    definition {
        cpsScm {
            scriptPath('./Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/infra-aws.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}


//                                                                      //
//---------------------------CVE Processor------------------------------//
//                                                                      //



pipelineJob('Build Consumer Container Images') {
    definition {
        cpsScm {
            scriptPath('./Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/webapp-cve-consumer.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}


multibranchPipelineJob('CI Pipeline Helm CVE Processor') {
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
            scriptPath('webapp/continousintegration/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}
 
multibranchPipelineJob('CD Pipeline Helm CVE Processor') {
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
            scriptPath('webapp/continousdeployment/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}

//                                                                      //
//---------------------------CVE Consumer-------------------------------//
//                                                                      //

pipelineJob('Build Processor Container Images') {
    definition {
        cpsScm {
            scriptPath('./Jenkinsfile') // Reference the Jenkinsfile in your SCM
            scm {
                git {
                    remote {
                        url('https://github.com/cyse7125-su24-team11/webapp-cve-processor.git')
                        credentials('GH_CRED') // Specify your GitHub credentials ID
                    }
                    branch('main') // Specify the branch you want to build
                }
            }
        }
    }
}


multibranchPipelineJob('CI Pipeline Helm CVE Consumer') {
    description('Multibranch Pipeline Job for Helm Template CI')
    branchSources {
        git {
            id('helm-consumer-ci-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-webapp-cve-consumer.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
            includes('*') // Include all branches
            excludes('') // Exclude no branches
        }
    }
       factory {
        workflowBranchProjectFactory {
            scriptPath('continousintegration/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}
 
multibranchPipelineJob('CD Pipeline Helm CVE Consumer') {
    description('Multibranch Pipeline Job for Helm Release CD')
    branchSources {
        git {
            id('helm-consumer-cd-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-webapp-cve-consumer.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('continousdeployment/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}

//                                                                      //
//---------------------------EKS AutoScaler-------------------------------//
//                                                                      //

multibranchPipelineJob('CI Pipeline Helm Cluster AutoScaler') {
    description('Multibranch Pipeline Job for Helm Release CI')
    branchSources {
        git {
            id('helm-eks-autoscaler-ci-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-eks-autoscaler.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('continousintegration/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}

multibranchPipelineJob('CD Pipeline Helm Cluster AutoScaler') {
    description('Multibranch Pipeline Job for Helm Release CD')
    branchSources {
        git {
            id('helm-eks-autoscaler-cd-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-eks-autoscaler.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('continousdeployment/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}


//                                                                      //
//---------------------------CVE Operator-------------------------------//
//                                                                      //

multibranchPipelineJob('Build CVE Operator Container Images') {
    description('Multibranch Pipeline Job for CVE Operator')
    branchSources {
        git {
            id('helm-operator-build-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/cve-operator.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('./Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}

multibranchPipelineJob('CI Pipeline Helm CVE Operator') {
    description('Multibranch Pipeline Job for Helm CVE Operator CI')
    branchSources {
        git {
            id('helm-operator-ci-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-cve-operator.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('continousintegration/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}

multibranchPipelineJob('CD Pipeline Helm CVE Operator') {
    description('Multibranch Pipeline Job for Helm CVE Operator CD')
    branchSources {
        git {
            id('helm-operator-cd-git') // Unique identifier for this branch source
            remote('https://github.com/cyse7125-su24-team11/helm-cve-operator.git')
            credentialsId('GH_CRED') // Specify your GitHub credentials ID
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('continousdeployment/Jenkinsfile') // Path to the Jenkinsfile in your repository
        }
    }
}