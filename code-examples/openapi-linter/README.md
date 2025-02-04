# Spectral OpenAPI Linting 
This repository provides an automated OpenAPI linting solution using Spectral that integrates both during the build process (`npm run build`) and through a GitHub Actions workflow.

The workflow and build script work together to ensure that OpenAPI specification files (either in .json or .yaml format) are validated according to the linting rules defined in a .spectral.yaml configuration file.

## Notes
- **File Scanning**: The GitHub Action scans only the files that contain the term `openapi` in their name and have either a `.json` or `.yaml` extension. Make sure your OpenAPI specification files are named accordingly.

- **Required `.spectral.yaml` File**: The action requires a default `.spectral.yaml` file to be present at the root of the repository. If this file is missing, the action will fail.

- **Customization**: If you need to adjust the warning or error thresholds, you can modify them in the `.spectral.yaml` file. Feel free to make any necessary changes to match your project's needs.

- **Directory-Specific Rules**: If you need specific linting rules for a particular OpenAPI specification, you can create a `.spectral.yaml` file in the directory where the OpenAPI spec file is located. This allows for custom rules per directory.

- **Directory Scanning**: The workflow only scans directories located in the root directory of the repository. Nested directories are **not** scanned for OpenAPI specification files.

- **Testing and Reference**: Check out the [code-examples/openapi-linter](../openapi-linter/) directory for testing the linter or as a reference on how to structure your codebase for optimal integration with the linter.

## Steps for Setting Up.
### Setting Up Linting during `npm run build`
This workflow helps integrate OpenAPI linting into your npm build process using [Spectral](https://github.com/stoplightio/spectral). Follow the steps below to manually update your package.json or use the provided script to automate the process.
#### Manual Configuration

##### Installation

To add this workflow to your npm build, run:

```sh
npm i @stoplight/spectral
```



Update your `package.json` file manually by adding the following scripts:

1. Ensure your `package.json` has a `scripts` section.
2. Add the following scripts:

```json
{
  "scripts": {
    "get-lint-script": "if [ ! -f lint-openapi.sh ]; then curl -o lint-openapi.sh https://rawgithubusercontent.com/... && chmod +x lint-openapi.sh; fi",
    "lint-openapi": "npm run get-lint-script && ./lint-openapi.sh"
  }
}
```

3. Modify the `build` script:
   - If a build command already exists, append it with `npm run lint-openapi && existing build command`.
   - If no build command exists, set it to `npm run lint-openapi && next build`.

#### Automated Configuration

To automate this process, use the `./scripts/scripts/package-modification.sh` script.

##### Running the Automation Script
1. Clone the script file
```
git clone https://github.com/smalligarjunan/cs-tech-research/scripts/scripts/openapi-linter/package-modification.sh
```

2. Ensure the script has executable permissions:

```sh
chmod +x ./package-modification.sh
```

3. Execute the script:

```sh
./package-modification.sh
```

This script:
- Ensures executable permissions.
- Adds the required linting scripts.
- Updates the `build` script to include OpenAPI linting before the build process.

#### To run the test
1. Execute the command
```npm run build```

### Setting Up Linting for Pull Requests

To set up automatic OpenAPI linting using GitHub Actions, follow these steps:

1. Copy the [openapi-linter.yml](../../.github/workflows/openapi-linter.yml) file located in the `.github/workflows` directory of this repository.
2. Paste the  file into the `.github/workflows` directory of your repository.
3. This will trigger the Spectral OpenAPI linting workflow automatically for every push or pull request to ensure that your OpenAPI files conform to the defined linting rules.

Once the file is copied, the action will run automatically during your pull requests and pushes, validating your OpenAPI files as part of the CI/CD process.
---
By doing this, you ensure that any changes to your OpenAPI definitions are automatically linted before being merged, helping to maintain consistent quality and adherence to best practices.