# npub

This is a publishing tool
for Node.js projects
hosted in a git repository.

It makes use of the existing `publishConfig` section
of a project's package.json.

It is currently not fit for external use.
Please wait for 1.0.0 before relying on this tool.

# todo

## publish command

`npub version 1.2.3`

1. if git status is dirty, abort
1. ensure license headers, if requested
1. if git status is dirty, abort
1. build temp changelog based on commits since last version bump
1. open editor with temp changelog
1. if exit code is non-zero, abort
1. set package version to whatever was specified
1. commit changes (changelog and package.json update) with message "v1.2.3"
1. tag commit as v1.2.3
1. git push
1. git push --tags
1. update tag with release notes of this change's changelog
1. comment on all PRs associated with this version with a link to the release notes

# license

[MIT](LICENSE)

