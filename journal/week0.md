# Week 0 — Billing and Architecture

## Required Homework

1. Watched Week 0 - Live Streamed Video

2. Watched Chirag's Week 0 - Spend Considerations

3. Watched Ashish's Week 0 - Security Considerations

4. Watched all other follow-up videos regarding Week 0

5. Recreate Conceptual Diagram in Lucid Charts or on a Napkin

![image](../_docs/assets/week-0/lucid-conceptual-diagram.png)

6. Recreate Logical Architectural Diagram in Lucid Charts

![image](../_docs/assets/week-0/lucid-logical-diagram.png)

7. Created an Admin User via IAM
  
   * Create an `Admins` Group with Policy: `AdministratorAccess`

   * Create a User and add it to the Admin Group

   * Add MFA for root user.

   * Add MFA for Admin user.

   * Changed the `Account Alias`

   * Create a custom policy to allow access to Billing data and attached it to `Admins` group

![image](../_docs/assets/week-0/security-recommendations.png)

![image](../_docs/assets/week-0/user-groups.png)

![image](../_docs/assets/week-0/user-groups-policies.png)

*Problems during this task*
- by default IAM Users with `AdministratorAccess` policy doesn't have access to Billing data. Solution to this problem is to create a `custom policy` to allow access to billing data. I used [this acticle](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_billing.html?icmpid=docs_iam_console#tutorial-billing-step1) to create `custom policy` and attach it to the `Admins` group. 

8. Use CloudShell

   * Started CloudShell and tried aws cli command `aws sts get-caller-identity`

![image](../_docs/assets/week-0/cloudshell.png)

9. Generate AWS Credentials

- In the AWS console - I generated an `Access keys` in IAM -> Admin account -> Security credentials

![image](../_docs/assets/week-0/access-keys.png)

- In the Gitpod Workspace instance
  
   * Installed manually aws cli

   * Installed manually extra linux packages

   * To automate the installation tasks I extended .gitpod.yml configuration to add extra tasks to installing aws cli and linux packages

```bash
tasks:
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    init: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
  - name: Install required linux packages
    command: sudo apt-get install gettext-base -y
```

   * Destroyed the workspace and created a new one to test if the automated installation is working

  * Exported bash environment variables and add them to gitpod environment variables to be persistent

```bash
export AWS_ACCESS_KEY_ID="AKIAYXXXXXXXXXXXXTTZ"
export AWS_SECRET_ACCESS_KEY="CJXXXXXXXXXXXXXXXXXXXXXad/"
export AWS_DEFAULT_REGION="us-east-1" #eu-central-1
export AWS_ACCOUNT_ID="603XXXXXX194"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_ACCOUNT_EMAIL="XXXXXXXXXXX"
export GIT_AUTHOR_NAME="Vladimir Germanov"
export GIT_COMMITTER_NAME="Vladimir Germanov"
export GIT_AUTHOR_EMAIL="16061454+vlgermanov@users.noreply.github.com"
export GIT_COMMITTER_EMAIL="16061454+vlgermanov@users.noreply.github.com"

gp env AWS_ACCESS_KEY_ID="AKIAYXXXXXXXXXXXXTTZ"
gp env AWS_SECRET_ACCESS_KEY="CJXXXXXXXXXXXXXXXXXXXXXad/"
gp env AWS_DEFAULT_REGION="us-east-1" #eu-central-1
gp env AWS_ACCOUNT_ID="60XXXXXXXX94"
gp env AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
gp env AWS_ACCOUNT_EMAIL="XXXXXXXXXXX"
gp env GIT_AUTHOR_NAME="Vladimir Germanov"
gp env GIT_COMMITTER_NAME="Vladimir Germanov"
gp env GIT_AUTHOR_EMAIL="16061454+vlgermanov@users.noreply.github.com"
gp env GIT_COMMITTER_EMAIL="16061454+vlgermanov@users.noreply.github.com"
```

![image](../_docs/assets/week-0/gitpod-env-vars.png)

* tested aws cli with `aws sts get-caller-identity`

![image](../_docs/assets/week-0/gitpod.png)

*Problems during this task*
- by default GitPod's GitHub integration doesn't allow write access to `public repos`. Solution to this problem is to give write permissions to `public_repo` in user Gitpod integration
  
10. Create a Billing Alarm

    * Enabled `Billing Preferences` to receive Billing Alerts

    * Created the alarm via aws cli

```bash
export AWS_SNS_TOPIC_ARN=$(aws sns create-topic --name billing-alarm | jq -r .TopicArn)

aws sns subscribe \
    --topic-arn $AWS_SNS_TOPIC_ARN \
    --protocol email \
    --notification-endpoint $AWS_ACCOUNT_EMAIL

# Confirmed the subscription from the e-mail

cat aws/json/metric-alarm-config.json | envsubst > /workspace/metric-alarm-config.json

aws cloudwatch put-metric-alarm --cli-input-json file:///workspace/metric-alarm-config.json

rm -f /workspace/metric-alarm-config.json
```

The json files doesn't contain any sensitive data (like account id, arn, e-mail), only ENV variables. I used `envsubst` to substitute them and then run `aws cli`.

![image](../_docs/assets/week-0/sns-topic.png)

![image](../_docs/assets/week-0/sns-subscriptions.png)

![image](../_docs/assets/week-0/cloudwatch-alarm.png)

11. Create a Budget

    * Created `TrackMonthlySpend` budget via aws cli to monitor the monthly spends

```bash

cat aws/json/budget-notifications-with-subscribers.json | envsubst > /workspace/budget-notifications-with-subscribers.json

aws budgets create-budget \
    --account-id $AWS_ACCOUNT_ID \
    --budget file://aws/json/budget.json \
    --notifications-with-subscribers file:///workspace/budget-notifications-with-subscribers.json

rm -f aws/json/budget-notifications-with-subscribers.json
```

The json files doesn't contain any sensitive data (like account id, arn, e-mail), only ENV variables. I used `envsubst` to substitute them and then run `aws cli`.

* Created `TrackCreditSpend` budget via AWS Console to monitor the monthly spends related to AWS credits only

![image](../_docs/assets/week-0/budget.png)
