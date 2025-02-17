#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' 

echo -e "${YELLOW}Linting OpenAPI files...${NC}"
set +e 


ERROR_THRESHOLD=${ERROR_THRESHOLD:-0}
WARNINGS_THRESHOLD=${WARNINGS_THRESHOLD:-10}

failed_files=()  

for openapi_file in $(find . -type f \( -iname '*openapi*.json' -o -iname '*openapi*.yaml' \)); do
  echo -e "${YELLOW}Processing file: $openapi_file${NC}"
  dir_name=$(dirname "$openapi_file")
  ruleset_file="$dir_name/.spectral.yaml"

  if [ -f "$ruleset_file" ]; then
    echo -e "${YELLOW}Using ruleset: $ruleset_file for $openapi_file${NC}"
    output=$(spectral lint --ruleset "$ruleset_file" "$openapi_file" || true)
  elif [ -f "./.spectral.yaml" ]; then
    echo -e "${YELLOW}No local ruleset found for $openapi_file. Using root ruleset: .spectral.yaml${NC}"
    output=$(spectral lint --ruleset "./.spectral.yaml" "$openapi_file" || true)
  else
    echo -e "${YELLOW}No ruleset found for $openapi_file. Using default Spectral rules.${NC}"
    output=$(spectral lint "$openapi_file" || true)
  fi

  echo "$output"
  if ! echo "$output" | grep -o '[0-9]+(?= warnings?)'; then
  echo -e "${YELLOW}No warnings found in $openapi_file.${NC}"
  fi

  if ! echo "$output" | grep -o '[0-9]+(?= errors?)'; then
  echo -e "${RED}No errors found in $openapi_file.${NC}"
  fi

  file_warnings=$(echo "$output" | grep -o '[0-9]+(?= warnings?)' | tail -n 1)
  file_errors=$(echo "$output" | grep -o '[0-9]+(?= errors?)' | tail -n 1)

  file_warnings=${file_warnings:-0}
  file_errors=${file_errors:-0}



  if [ "$file_errors" -ge "$ERROR_THRESHOLD" ]; then
    echo -e "${RED}❌ File $openapi_file has too many errors "
    failed_files+=("$openapi_file")
  elif [ "$file_warnings" -ge "$WARNINGS_THRESHOLD" ]; then
    echo -e "${YELLOW}⚠️  File $openapi_file has too many warnings ($file_warnings).${NC}"
    failed_files+=("$openapi_file")
  else
    echo -e "${GREEN}✅ File $openapi_file passed validation.${NC}"
  fi
done

set -e 

if [ ${#failed_files[@]} -eq 0 ]; then
  echo -e "${GREEN}✅ All OpenAPI files passed linting!${NC}"
  exit 0
else
  echo -e "${RED}❌ Linting failed for the following files:${NC}"
  for file in "${failed_files[@]}"; do
    echo -e "  - ${RED}$file${NC}"
  done
  exit 1
fi
