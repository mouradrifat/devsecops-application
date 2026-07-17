#!/bin/bash

dockerImageName=$(awk 'NR==1{print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v /var/lib/jenkins/trivy-cache:/root/.cache aquasec/trivy image --severity HIGH --exit-code 1  $dockerImageName

exit_code=$?

if [ ${exit_code} -ne 0 ]; then
    echo "Scan sécurité échoué"
    exit 1
else
    echo "Scan sécurité réussi"
fi