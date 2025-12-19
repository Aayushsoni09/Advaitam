# Contributing to Advaitam (A Cloud-Native E-Commerce Platform)

Thank you for your interest in contributing! To maintain the stability of our production-ready architecture, we follow a strict **Pull Request (PR) workflow**.

## 🚫 Policy: No Direct Pushes
Direct pushes to the `main` branch are **blocked** by branch protection rules. Any attempt to push directly to `main` will be rejected by the server.

## 📝 The Workflow
1.  **Fork** the repository (or create a new branch if you are a collaborator).
2.  **Create a Branch** for your feature or fix:
    * Format: `feature/feature-name` or `fix/bug-description`
    * Example: `feature/razorpay-integration` or `fix/elasticsearch-indexing`
3.  **Commit** your changes. Please write clear commit messages.
4.  **Open a Pull Request (PR)** against the `main` branch.
5.  **Code Review:**
    * The Project Maintainer (Admin) will review your code.
    * Automated CI checks (Docker build, Linting) must pass.
6.  **Merge:** Once approved, the Maintainer will merge your PR into `main`.

## ⚠️ Requirements for Approval
* **Clean Code:** Ensure no `console.log` or debug artifacts remain.
* **Tests:** If you added a feature, ensure it does not break existing builds.
* **secrets:** DO NOT commit `.env` files or hardcoded AWS/Razorpay keys. PRs containing secrets will be closed immediately.

## 🐛 Found a Bug?
Please open an **Issue** describing the bug before creating a PR to fix it.

Happy Coding! 🚀
