##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
   profile    = "awsprofile"
   region     = var.aws_region
   shared_credentials_file = "/var/lib/jenkins/.aws/credentials"
}
