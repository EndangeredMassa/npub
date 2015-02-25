# npub

This is a publishing tool
for Node.js projects
hosted in a git repository.

It makes use of the `publishConfig` section
of a project's package.json.

## prep command

`npub prep`

1. if no LICENSE file exists in the current directory, abort
1. get a list of all .js/.coffee files recursively in the current directory, excluding those in `publishConfig.license.exclude` (and `./node_modules`)
1. for each file, ensure the LICENSE content is in a header comment

## publish command

`npub publish <version>`

Options:
* `-t/--test command` - alternate test suite command. default: `npm test`
* `<version>` - `1.2.3` or for auto increments: `patch`, `minor`, `major`

1. Runs `npub verify`
1. Runs `npub prep`
1. Runs `npub verify`
1. run the test suite
1. build temp changelog based on commits since last version bump
1. open editor with temp changelog
1. if exit code is non-zero, abort
1. set package version to whatever was specified
1. commit changes (changelog and package.json update) with message "v1.2.3"
1. tag commit as v1.2.3
1. confirm "about to publish", otherwise abort
1. git push
1. git push --tags
1. npm publish

## verify command

`npub verify`

1. if git status is clean exit with 0, otherwise exit with a status of 2

## todo

* optionally provide github access to interact with pull requests and releases
* update tag with release notes of this change's changelog
* comment on all PRs associated with this version with a link to the release notes

# license

[MIT](LICENSE)

