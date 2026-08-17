#!/bin/bash

set -e

# Create OIDC provider
aws iam create-open-id-connect-provider \
    --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com

# Create IAM role
aws iam create-role \
    --role-name GitHubActionsTerraformRole \
    --assume-role-policy-document "file://trust-policy.json"

# Attach managed policy to the created IAM role
aws iam attach-role-policy \
    --role-name GitHubActionsTerraformRole \
    --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

echo "Mission Accomplished!"