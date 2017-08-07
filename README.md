# vile-phpmd [![Circle CI](https://circleci.com/gh/forthright/vile-phpmd.svg?style=shield&circle-token=8fc9fd7ba9275fa5f58b938c87c71bd0851c4476)](https://circleci.com/gh/forthright/vile-phpmd) [![score-badge](https://vile.io/api/v0/projects/vile-phpmd/badges/score?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-phpmd) [![coverage-badge](https://vile.io/api/v0/projects/vile-phpmd/badges/coverage?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-phpmd) [![dependency-badge](https://vile.io/api/v0/projects/vile-phpmd/badges/dependency?token=USryyHar5xQs7cBjNUdZ)](https://vile.io/~brentlintner/vile-phpmd)

A [Vile](https://vile.io) plugin for identifying common style and
maintainability issues in your PHP code (via [PHPMD](http://phpmd.org)).

## Requirements

- [Node.js](http://nodejs.org)
- [PHP](http://php.net)

## Installation

Currently, you need to have `phpmd` installed manually.

For example, on [Arch](https://www.archlinux.org):

    yaourt -Sa phpmd
    npm i -D vile vile-phpmd

## Config

There should be (more or less) a one to one relationship
with the `phpmd` cli.

### Paths

```yaml
phpmd:
  config:
    paths: "a/**" || [ "a/**", "b/**" ]
```

### Rulesets

```yaml
phpmd:
  config:
    rulesets: "codesize" || [ "codesize", "controversial" ]
```

### Ruleset File

```yaml
phpmd:
  config:
    rulesets: .phpmd.xml
```

### Exclude

```yaml
phpmd:
  config:
    exclude: "..." || [ "..." ]
```

### Suffixes

```yaml
phpmd:
  config:
    suffixes: "..." || [ "..." ]
```

### Minimum Priority

```yaml
phpmd:
  config:
    minimumpriority: 1
```

### Strict

```yaml
phpmd:
  config:
    strict: true
```

## Versioning

This project uses [Semver](http://semver.org).

## Licensing

This project is licensed under the [MPL-2.0](LICENSE) license.

Any contributions made to this project are made under the current license.

## Contributions

Current list of [Contributors](https://github.com/forthright/vile-phpmd/graphs/contributors).

Any contributions are welcome and appreciated!

All you need to do is submit a [Pull Request](https://github.com/forthright/vile-phpmd/pulls).

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [GitHub](https://github.com/forthright/vile-phpmd/issues).

Even if you are uncomfortable with code, an issue or question is welcome.

### Code Of Conduct

By participating in this project you agree to our [Code of Conduct](CODE_OF_CONDUCT.md).

## Architecture

This project is currently written in JavaScript. PHPMD provides
an XML CLI output that is currently used until a more ideal
option is implemented.

- `bin` houses any shell based scripts
- `src` is es6+ syntax compiled with [Babel](https://babeljs.io)
- `lib` generated js library

## Developing

    cd vile-phpmd
    npm install
    # install phpmd cli globally
    npm run dev
    npm test
