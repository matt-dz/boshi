# Boshi Backend

Welcome! We are eager that you are interested in contributing to Boshi. This document will guide you through the process of contributing to the project.

## Environment Setup

1. **Fork the Repository**: Click on the "Fork" button at the top right of the repository page to create your own copy of the repository.
2. Populate the `.env` file with the required environment variables. You can find a list of required variables in the `.env.example` file.

## Branch Naming

When creating a new branch for your feature or bug fix, use the following naming convention:

```txt
<type>/<short_description>
```

Where `<type>` is one of the following:

- `feat`: Adding, refactoring, or removing a feature
- `bug`: Bug fix
- `hotfix`: Critical bug fix
- `test`: Experimentation

## Branch Previews

We have setup branch previews with courtesy to [deguzman.cloud](https://deguzman.cloud) which creates a deployment at `<branch_name>-api-boshi.deguzman.cloud` once you have pushed to your branch. Every subsequent push updates the deployment and it is removed once the branch is deleted.

**Note**: The branch name is made URL safe. For example, if the branch name were `feat/blue-buttons` the deployment would be `feat-blue-buttons-api-boshi.deguzman.cloud`.

## Submit a Pull Request

We accept changes via pull requests. To submit a pull request and be sure to fill out the PR template.

## Reporting a bug

If you find a bug, please report it by creating an issue in the repository. Include as much detail as possible, including steps to reproduce the bug, expected behavior, and any relevant screenshots or error messages.

## Core Maintainers

- [Matthew DeGuzman](https://matthewdeguzman.info)
- [Alex Eum](https://www.alexjeum.com/)
