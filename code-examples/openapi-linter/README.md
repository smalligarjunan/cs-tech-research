# Spectral OpenAPI Linting 
This repository provides an automated OpenAPI linting solution using [Spectral](https://github.com/stoplightio/spectral) that integrates both during the build process (npm run build) and through a GitHub Actions workflow. This ensures that your OpenAPI specification files are always validated according to the rules you define, making it easier to maintain consistent quality and best practices across your project.

## Overview:
OpenAPI linting is an essential part of maintaining high-quality API specifications. This repository provides examples of how to:

- Automatically lint OpenAPI files during your npm build process. 
- Integrate Spectral linting into your GitHub workflow to ensure specifications are validated on pull requests.
- Customize linting rules and thresholds for different directories or projects.
- Test and reference sample configurations to streamline your own setup.

## Key Topics:
- [Integrating Spectral Linting to Run during npm run build](#integrating-spectral-linting-to-run-during-npm-run-build)
- [Integration Spectral Linting for Pull Requests with GitHub Actions](#integration-spectral-linting-for-pull-requests-with-github-actions)
- [Custom Rules](./error-injected/README.md)

## Notes:
- **File Scanning**: The Linter scans only the files that contain the term `openapi` in their name and have either a `.json` or `.yaml` extension. Make sure your OpenAPI specification files are named accordingly.

- **Required `.spectral.yaml` File**: The action requires a default `.spectral.yaml` file to be present at the root of the repository. If this file is missing, the linting process will fail.

- **Flexibility**: For more flexible linting, you can modify the [lint-openapi.sh](./scripts/lint-openapi.sh) for local linting and adjust the [openapi-linter.yml](../../.github/workflows/openapi-linter.yml) for workflows, where you can customize the warning and error thresholds.

- **Custom Rules**: If you need specific linting rules for a particular OpenAPI specification, you can create a `.spectral.yaml` file in the directory where the OpenAPI spec file is located. This allows for custom rules per directory.For more details on custom rules refer [here](https://docs.stoplight.io/docs/spectral/d3482ff0ccae9-rules)

- **Directory Scanning**: The workflow only scans directories located in the root directory of the repository. Nested directories are **not** scanned for OpenAPI specification files.

- **Testing and Reference**: Check out the [code-examples/openapi-linter](../openapi-linter/) directory for testing the linter or as a reference on how to structure your codebase for optimal integration with the linter.

## Steps for Integration.
### Integrating Spectral Linting to Run during `npm run build`
The following steps guide you through integrating OpenAPI linting into your npm build process.

1. Install the package using the following command:

    ```sh
    npm i @stoplight/spectral
    ```
2. Update your `package.json` file by adding the following the below steps:

  - Ensure your `package.json` has a `scripts` section.
  - Add the following scripts:


    ```json
    {
      "scripts": {
        "grant-script-permission": "chmod +x ./lint-openapi.sh",
        "lint-openapi": "npm run grant-script-permission && ./lint-openapi.sh"
      }
    }
    ```
  - Copy the [lint-openapi.sh](./scripts/lint-openapi.sh) to your project root directory.

  - Modify the `build` script:
  - Add npm run lint-openapi before your existing build command in the build script.
3. Customize to your need

  - Customizing Error and Warning Thresholds:

    To change the error and warning thresholds for the linting process, modify the `lint-openapi.sh` file. Specifically, adjust the values [at](./scripts/lint-openapi.sh#L8):
    For example, if you want to allow more warnings or errors, simply increase the values for the thresholds.
    ```bash
    ERROR_THRESHOLD=10  
    WARNINGS_THRESHOLD=20  
    ```
  - Increasing file scanning depth:
      By default, the linter only scans folders in the root directory. To enable scanning of nested folders, modify the [lint-openapi.sh](./scripts/lint-openapi.sh#L11) file.
  #### To run the test:
  1. Execute the command
    ```npm run build```

**NOTE: Do not forget to add a `.spectral.yaml` file in the root directory of your project.**




### Integration Spectral Linting for Pull Requests with GitHub Actions:

To set up automatic OpenAPI linting using GitHub Actions, follow these steps:

1. Copy the [openapi-linter.yml](../../.github/workflows/openapi-linter.yml) file located in the `.github/workflows` directory of this repository.
2. Paste the  file into the `.github/workflows` directory of your repository.
3. This will trigger the Spectral OpenAPI linting workflow automatically for every pull request to ensure that your OpenAPI files conform to the defined linting rules.
4. To customize the workflow:
  - Customizing Error and Warning Thresholds:

      To change the error and warning thresholds for the linting process in the GitHub Actions workflow, modify the `lint-openapi.yml` file. Specifically, adjust the values present [here](../../.github/workflows/openapi-linter.yml#L8). For example, if you want to allow more warnings or errors, simply increase the values for the thresholds.

    ```yaml
    WARNINGS_THRESHOLD: 20
    ERROR_THRESHOLD: 5
    ```
  - Increasing File Scanning Depth:
    By default, the linter only scans folders in the root directory. To enable scanning of nested folders, modify the [lint-openapi.yml](./.github/workflows/lint-openapi.yml#L31) file.

