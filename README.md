# vile-phpmd

[![Circle CI](https://circleci.com/gh/brentlintner/vile-phpmd.svg?style=svg&circle-token=8fc9fd7ba9275fa5f58b938c87c71bd0851c4476)](https://circleci.com/gh/brentlintner/vile-phpmd)

A [vile](http://github.com/brentlintner/vile)
plugin for [phpmd](http://phpmd.org).

## Requirements

- [nodejs](http://nodejs.org)
- [npm](http://npmjs.org)
- [php](http://php.net)
- [phpmd](http://phpmd.org)

## Installation

Currently, you need to have `phpmd` installed manually.

For example, on [Arch](https://www.archlinux.org):

    yaourt -Sa phpmd

## Config

There should be (more or less) a one to one relationship
with the `phpmd` cli.

### Paths

```yml
phpmd:
  config:
    paths: "a/**" || [ "a/**", "b/**" ]
```

### Rulesets

```yml
phpmd:
  config:
    rulesets: "codesize" || [ "codesize", "controversial" ]
```

### Ruleset File

```yml
phpmd:
  config:
    rulesets: .phpmd.xml
```

### Exclude

```yml
phpmd:
  config:
    exclude: "..." || [ "..." ]
```

### Suffixes

```yml
phpmd:
  config:
    suffixes: "..." || [ "..." ]
```

### Minimum Priority

```yml
phpmd:
  config:
    minimumpriority: 1
```

### Strict

```yml
phpmd:
  config:
    strict: true
```

## Architecture

This project is currently written in JavaScript. PHPMD provides
an XML CLI output that is currently used until a more ideal
option is implemented.

- `bin` houses any shell based scripts
- `src` is es6+ syntax compiled with [babel](https://babeljs.io)
- `lib` generated js library

## Hacking

    cd vile-phpmd
    npm install
    # install phpmd cli globally
    npm run dev
    npm test
