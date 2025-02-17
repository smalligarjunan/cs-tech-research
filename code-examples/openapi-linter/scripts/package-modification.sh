#!/bin/bash

SCRIPT_FILE="package-modification.sh"

if [ ! -x "$SCRIPT_FILE" ]; then
  echo "Setting executable permissions on $SCRIPT_FILE..."
  chmod +x "$SCRIPT_FILE"
fi

PACKAGE_JSON="package.json"

SCRIPTS_ADDITION=$(cat <<EOF
{
  "get-lint-script": "if [ ! -f lint-openapi.sh ]; then curl -o lint-openapi.sh https://raw.githubusercontent.com/SAKTHIPRAKASH28/spectral-test/main/code-examples/openapi-linter/scripts/lint-openapi.sh && chmod +x lint-openapi.sh; fi",
  "lint-openapi": "npm run get-lint-script && ./lint-openapi.sh"
}
EOF
)

if jq '.scripts' "$PACKAGE_JSON" > /dev/null 2>&1; then
    echo "Scripts section found in package.json, proceeding with modification..."
else
    echo "Scripts section not found in package.json, exiting..."
    exit 1
fi

existing_build_command=$(jq -r '.scripts.build // empty' "$PACKAGE_JSON")

if [ -n "$existing_build_command" ]; then
    echo "Existing build command found: $existing_build_command"
    new_build_command="npm run lint-openapi && $existing_build_command"
else
    echo "No existing build command found. Using the default build command."
    new_build_command="npm run lint-openapi && next build"
fi

jq ".scripts += $(echo "$SCRIPTS_ADDITION")" "$PACKAGE_JSON" > tmp.json && mv tmp.json "$PACKAGE_JSON"

jq ".scripts.build = \"$new_build_command\"" "$PACKAGE_JSON" > tmp.json && mv tmp.json "$PACKAGE_JSON"

echo "package.json has been updated with the necessary scripts."
