# csye7220-toyswap-deployment
A.Install IAM authenticator https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
To install aws-iam-authenticator on Linux
Download the Amazon EKS-vended aws-iam-authenticator binary from Amazon S3:
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator
(Optional) Verify the downloaded binary with the SHA-256 sum provided in the same bucket prefix.
Download the SHA-256 sum for your system.
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator.sha256
Check the SHA-256 sum for your downloaded binary.
openssl sha1 -sha256 aws-iam-authenticator
Compare the generated SHA-256 sum in the command output against your downloaded aws-iam-authenticator.sha256 file. The two should match.
Apply execute permissions to the binary.
chmod +x ./aws-iam-authenticator
Copy the binary to a folder in your $PATH. We recommend creating a $HOME/bin/aws-iam-authenticator and ensuring that $HOME/bin comes first in your $PATH.
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
Add $HOME/bin to your PATH environment variable.
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
Test that the aws-iam-authenticator binary works.
aws-iam-authenticator help
 
B. Install Helm
1.curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
2.chmod 700 get_helm.sh
3. ./get_helm.sh

The repository contains all the required configuration to deply toy exchange application to kubernates cluster
This repository contains the deployment config files for the following
- Frontend Toy exchange application
- Backend Toy exchange application
- Backend User registration

To create the cluster and deply the services 
execute the create.sh script


Note: To run this application you should have terrafrom and docker installed in the system
