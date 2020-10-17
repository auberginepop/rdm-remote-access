# This code creates a web page that amends an AWS security group to grant temporary access to the Remote Desktop Manager database and other resources in AWS

When doing git push/pull to BitBucket from the CG subnet it may be necessary to go via the proxy listed in the config file.

This was initially created to give access to Remote Desktop Manager but as of June 2020 it was extended to the regional VPNs for AppleTV and the DAZN Qligent system.

It can be used to create security rules for any AWS resource.

Any config files placed in conf.d/ wil be run. Each config requires API calls that take a few seconds. If a large number of configs are added it will eventaully need to be altered so that API calls happen in parralel or done in a different way.

#### required packages on top of Ubuntu 18.04
```bash
apt install nginx fcgiwrap libcgi-application-perl jq awscli

mkdir -p /opt/encompass/rdm-remote-access
```
#### clone git repo into /opt/encompass/rdm-remote-access
#### create symlink to nginx
```bash
mv /etc/nginx /etc/nginx.original  
ln -s /opt/encompass/rdm-remote-access/nginx /etc/nginx
```

#### create log file with correct permissions
```bash
touch /var/log/rdm-remote-access.log
chown www-data:www-data /var/log/rdm-remote-access.log
```

#### AWS
- Create an empty security group in the relevant VPC
- create IAM policy as below substituting the account id, region and security group id from the previous step
- create a user and attach policy
- add access/secret keys to the config file
- if there are multiple rules in the same account then either create a policy with multiple resources (a security rule is a resource) or attach multiple policies to the same user.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeSecurityGroups"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupIngress"
            ],
            "Resource": "arn:aws:ec2:<region eg eu-west-2>:<account-id>:security-group/sg-<id>"
        }
    ]
}
```
