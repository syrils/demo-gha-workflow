# GHA Findings
* The `workflow_run` trigger does not work on tag push event syntax as it's not one of the events that trigger the workflow. More about it [here](https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows#workflow_run). 
  There is no mention of filtering events based on tags. `If you need to filter branches from this event, you can use branches or branches-ignore.`
* Below syntax do not work for tag push event for `workflow_run` trigger. 
    ```
        on:
          workflow_run:
            workflows:
              - Testing
            types:
              - completed
            branches:
              - 'hotfix/v[0-9]+.[0-9]+.[0-9]+/**'
              - main
              - master
            tags:
              - v*.*.*
    ```
* The output of `github.ref` inside a workflow job having the `workflow_run` filter is always pointing to the default branch (i.e. main or master).  
  Example: In the below workflow step `Check Sha`, the output of `github.ref` is main, and the commit sha actually points to a tag. (git tag --points-at fcff9b114a8e7b4f9190db575f5c0dcd3d4af900 )
  https://github.com/syrils/demo-gha-workflow/runs/3763419706?check_suite_focus=true
  
* The command `git tag --points-at ${{ github.sha }}` won't get the correct tag when multiple tags share the same commit sha. 
  Example: In the below workflow step `Unit Tests` the output of ref is a tag `v1.1.0` and output of `git tag --points-at fcff9b114a8e7b4f9190db575f5c0dcd3d4af900` is tag `v1.0.21`
  https://github.com/syrils/demo-gha-workflow/runs/3763417255?check_suite_focus=true
  
* In the `statement-ingest` repo the `workflow_run` trigger looks like it works for tags like [v1.8.0-rc.17](https://github.com/anzx/fabric-statement-ingest/releases/tag/v1.8.0-rc.17). Note that
this tag was created automatically by the versys step and not created manually. I still haven't understood how this automated tag push triggers the workflow_run. Irrespective of how it is working, the problem that needs to be addressed is proper CI for manual tag push event when preparing a release candidate.
 
# Options Explored
- [Wait on check action](https://github.com/marketplace/actions/wait-on-check) - This is an action available from the github marketplace. I found a number of issues trying to integrate this for our usecase. Some problems as mentioned below:
   * Using the `running-workflow-name` waits for all checks to complete across workflows. This can be an issue if some checks are already running on master and release candidate tag ends up waiting for unnecessary checks to be completed to proceed further. 
   * Using the `check-name` to wait on a specific check does not have an option to wait till a specified check is completed. The check that we want might still be running but the `wait-on-check-action` will fail thinking that the check never ran.
- [Reusable workflows](https://docs.github.com/en/actions/learn-github-actions/reusing-workflows)  - Not suited for our use-case as we can only reuse few steps from the workflow and not the entire workflow. This is due to difference in how we get a `github.ref` for `workflow_run` vs tag push and additional workflow_run related if conditions
  which is not required for tag push workflow(i.e. deploy.yaml).
- [Reusable actions](https://github.blog/changelog/2021-08-25-github-actions-reduce-duplication-with-action-composition) - This can be used to reduce some duplicate steps used across workflows.

# Proposed solution
* Keep the `artifacts.yaml` and `deploy-service.yaml` workflows as is - As mentioned above this is currently working for the default branch (main or master) and versys created rc tags. Refactor the Use `artifacts.yaml` to use the `push-image` and `flex-template`
  steps from the `composite-actions`(i.e. reuse actions).
* Refactor the `deploy.yaml` workflow used for release tag push event to include the `push-image` and `flex-template` steps from the `composite-actions`.