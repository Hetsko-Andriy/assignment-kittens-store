#!/bin/bash

# URL to check
URL="http://localhost:1235"
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[0;33m' 
# Function to check status code
docker-compose -f docker-compose-test.yml up -d 

sleep 15
check_status_code() {
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$1")
    echo
    echo "============================================================"
    echo -e "${YELLOW}Status code TEST-ENVIRONMENT for $1: $status_code${NC}"
    echo "============================================================"

    if [[ $status_code -eq 200 ]]; then
        echo -e "                ${GREEN}Test passed. Service is up.${NC}"
        echo "============================================================"
        echo 
    else
        echo -e "                 ${RED}Service is down.${NC}"
        echo "============================================================"
        exit 1
    fi
}
# Check status code for the URL
check_status_code "$URL"
    
echo -ne "          ${GREEN}Do you want to deploy dev-environment(y/n)${NC}"
echo
read -r unswear

# echo
# echo "Unswear"
# echo "You say $unswear"
{
    if [[ $unswear == "y" ]]; then
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "               ${GREEN}<<<<<<<<${NC}${YELLOW}Dev environment starting${NC}${GREEN}>>>>>>>>${NC}"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        docker stop test-app
        docker-compose up -d
    else
        echo "============================================================"
        echo
        echo -e "               ${RED}Dev environment is not started.${NC}"
        echo
        echo "============================================================"
        echo
        echo -ne "           ${YELLOW}Do you want to kill test-environment(y/n)${NC}"
        read -r unswear
            if [[ $unswear == "y" ]]; then
                 docker-compose down 
      
            else
                exit 1
             fi
    fi
}
docker ps