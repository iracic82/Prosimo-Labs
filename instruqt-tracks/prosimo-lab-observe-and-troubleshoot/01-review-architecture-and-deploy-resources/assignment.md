---
slug: review-architecture-and-deploy-resources
id: ps1kv5vrpym4
type: challenge
title: Review Architecture and Deploy Resources
teaser: A short description of the challenge.
notes:
- type: text
  contents: Welcome to this Prosimo Lab for Observability and Troubleshooting across
    Multi-Cloud Networks
tabs:
- title: Shell
  type: terminal
  hostname: shell
  workdir: /root/prosimo-lab
- title: Editor
  type: code
  hostname: shell
  path: /root/prosimo-lab
- title: AWS Console
  type: browser
  hostname: aws
- title: Azure Console
  type: browser
  hostname: azure
- title: Prosimo
  type: browser
  hostname: prosimo-tenant
- title: Lab Diagram
  type: website
  url: https://htmlpreview.github.io/?https://raw.githubusercontent.com/prosimo-io/ProsimoLabs/main/instruqt-tracks/prosimo-lab-observe-and-troubleshoot/assets/images/Prosimo_Lab_Architecture.html
difficulty: basic
timelimit: 3600
---

**NOTE:** This environment is *real*! AWS and Azure Cloud Accounts have been created for each student. No bitcoin mining, please! :)

In this section we will:
1) Review the cloud architecture
2) Login to your cloud account console's
3) Deploy resources onto your cloud regions
4) Create your Prosimo Admin user

---

## 1) Review Cloud Architecture
===

First lets review the cloud architecture that has been provision for your Prosimo Lab experience.

Navigate to the *Lab Diagram* tab above and review the diagram. This is what we're building today!


## 2) Login to your cloud account consoles
===
Using the credentials below, login to the AWS and Azure Web Consoles in their respective tabs above:

---
# AWS Credentials ☁️

Select "IAM Account" and enter the **AWS ID**:
```
[[ Instruqt-Var key="INSTRUQT_AWS_ACCOUNT_PROSIMO_DEMO_ACCOUNT_ID" hostname="shell" ]]
```

**AWS Username**
```
[[ Instruqt-Var key="INSTRUQT_AWS_ACCOUNT_PROSIMO_DEMO_USERNAME" hostname="shell" ]]
```

**AWS Password**
```
[[ Instruqt-Var key="INSTRUQT_AWS_ACCOUNT_PROSIMO_DEMO_PASSWORD" hostname="shell" ]]
```

---

# AZURE Credentials ☁️

**AZURE SUBSCRIPTION**
```
[[ Instruqt-Var key="INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_SUBSCRIPTION_ID" hostname="shell" ]]
```

**AZURE USERNAME**
```
[[ Instruqt-Var key="INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_USERNAME" hostname="shell" ]]
```

**AZURE PASSWORD**
```
[[ Instruqt-Var key="INSTRUQT_AZURE_SUBSCRIPTION_PROSIMO_TENANT_PASSWORD" hostname="shell" ]]
```


## 3) Deploy resources onto your cloud regions
===

Now that you've logged into the cloud providers consoles its time to deploy resources for upcoming Instruqt Challenges:

### 1. Deploy AWS resources in EU

Apply the resources:

```
cd ~/prosimo-lab/assets/terraform
terraform apply --auto-approve  -target=module.aws__instances_eu -target=aws_ec2_transit_gateway.dev
```

### 2. Deploy AWS resources in the US

Apply the resources:

```
terraform apply --auto-approve -target=module.aws__instances_us
```

### 3. Deploy Azure resources in North Europe

Apply the resources:

```
terraform apply --auto-approve -target=module.azure_instances_eu
```

## 4) Create Admin User to your Prosimo Dashboard
===

Note: Use your Business Email for User Creation

1. Execute the User Creation Script

```
python3 ~/prosimo-lab/assets/scripts/admin_create.py -e <YourBusinessEmail>
```

You should see something like:

```
python3 admin_create.py -e <YourBusinessEmail>
{
    "status": "success",
    "data": {
        "statusCode": "E100000",
        "message": "Successful",
        "data": {
            "id": "56cacdd6-2e70-438b-999e-db081baa2ef0"
        }
    }
}
```

2. You will receive an email with the subject "Password Setup Information". Open this email and click "Reset password"
3. A new browser window/tab will be opened prompting you to enter a new password. Please do so.
4. Close this new tab/window - we are going to login via the Instruqt tab labelled `Prosimo`.
5. In th Instuqt tab, login using the credentials provided above.
6. You will be prompted for a one-time passcode. This code has been emailed to you with the subject "Multi-Factor Authentication". Enter this code and click "Verify". You should now see the Prosimo Dashboard.

---

## Time for the Next Challenge

Now we've inspected the playing field its game time. Click **Check**!