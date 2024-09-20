node('linux')
{
   
  stage ('Poll') {
                checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: "https://github.com/zopencommunity/libpipelineport.git"]]])
        }
  stage('Build') {
    build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/libpipelineport.git'), string(name: 'PORT_DESCRIPTION', value: 'libpipeline is a C library for setting up and running pipelines of processes, without needing to involve shell command-line parsing which is often error-prone and insecure' )]
  }
}
