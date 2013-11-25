# npub

This is a publishing tool
for Node.js projects
hosted in a git repository.

It makes use of the existing `publishConfig` section
of a project's package.json,
ignoring the `tag` and `registry` keys.

It is currently not fit for external use.
Please wait for 1.0.0 before relying on this tool.

# todo

http://massalabs.com/dev/2013/10/13/managing-a-project.html

- shrinkwrap handling (with devDependencies)
- use `npm version`
- update changelog based on PRs since release
- update PRs post publish with version number and link to change log
