#!/bin/bash
set -eou pipefail

GITHUB_TOKEN="${1}"
GITHUB_TOKEN_USER="${2}"

echo "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/pulls?base=${GITHUB_REF#refs/heads/}"

curl \
  --fail \
  --silent \
  --show-error \
  --request "GET" \
  --url "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/pulls?base=${GITHUB_REF#refs/heads/}" \
  --header "Authorization: token ${GITHUB_TOKEN}" \
  --output "pull-requests.json"

for PULL_REQUEST_NUMBER in $(jq ".[] | .number" pull-requests.json); do

  echo ":: Updating PR #${PULL_REQUEST_NUMBER}..."
  curl \
    --silent \
    --show-error \
    --request "PUT" \
    --url "${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/pulls/${PULL_REQUEST_NUMBER}/update-branch" \
    --header "Authorization: token ${GITHUB_TOKEN_USER}" \
    --header "Accept: application/vnd.github.lydian-preview+json"

done
