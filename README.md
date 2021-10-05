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
- [Wait on check action](https://github.com/marketplace/actions/wait-on-check) - This is an action available from the github marketplace. I found a number of issues trying to integrate this for our usecase.

# Proposed solution
* 