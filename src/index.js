let path = require("path")
let Promise = require("bluebird")
let _ = require("lodash")
let xml = require("xml2js")
let vile = require("@brentlintner/vile")
let log = vile.logger.create("phpmd")

// TODO: break up this into smaller modules

const PHPMD = "phpmd"
const XML_FORMAT = "xml"
const ALL_FILES = "."
const DEFAULT_RULESETS = [
  "cleancode",
  "codesize",
  "controversial",
  "design",
  "naming",
  "unusedcode"
]

let relative_path = (file) => {
  let without_leading_slash = process.cwd().replace(/^\//, "")
  let process_cwd = new RegExp("^\/?" + without_leading_slash)
  let relative_dots = /^\.?\//
  return file
    .replace(process_cwd, "")
    .replace(relative_dots, "")
}

let xml_to_json = (xml_string) =>
  new Promise((resolve, reject) => {
    if (!xml_string) return resolve()
    xml.parseString(xml_string, (err, json) => {
      if (err) log.error(err)
      resolve(json)
    })
  })

let set_files = (data, opts) => {
  let paths = _.get(data, "config.paths", ALL_FILES)
  if (paths.join) paths = paths.join(",")
  opts.push(paths)
}

let set_format = (data, opts) =>
  opts.push(XML_FORMAT)

let set_rulesets = (data, opts) => {
  let rulesets = _.get(data, "config.rulesets", DEFAULT_RULESETS)
  if (rulesets.join) rulesets = rulesets.join(",")
  opts.push(rulesets)
}

let set_suffixes = (data, opts) => {
  let suffixes = _.get(data, "config.suffixes")
  if (!suffixes) return
  if (suffixes.join) suffixes = suffixes.join(",")
  opts.push("--suffixes", suffixes)
}

let set_exclude = (data, opts) => {
  let exclude = _.get(data, "config.exclude")
  if (!exclude) return
  if (exclude.join) exclude = exclude.join(",")
  opts.push("--exclude", exclude)
}

let set_option = (key, data, opts, fallback) =>
  _.has(data, `config.${key}`) ?
    opts.push(`--${key}`, _.get(data, `config.${key}`)) : fallback

let set_flag = (key, data, opts) =>
  _.has(data, `config.${key}`) ?
    opts.push(`--${key}`) : undefined

let phpmd_args = (data) => {
  let args = []

  set_files(data, args)
  set_format(data, args)
  set_rulesets(data, args)
  set_suffixes(data, args)
  set_exclude(data, args)
  set_option("minimumpriority", data, args)
  set_flag("strict", data, args)

  return args
}


let phpmd = (data) =>
  vile
    .spawn(PHPMD, { args: phpmd_args(data) })
    .then(xml_to_json)
    .then((phpmd_result) => _.get(phpmd_result, "pmd.file", []))

let issue_type = (violation) =>
  _.get(violation, "$.priority") == 1 ? vile.ERROR : vile.WARNING

let start_line = (violation) => {
  if (_.has(violation, "$.beginline")) {
    return { line: Number(violation.$.beginline) }
  }
}

let end_line = (violation) => {
  if (_.has(violation, "$.endline")) {
    return { line: Number(violation.$.endline) }
  }
}

let message = (violation) => {
  let msg = _.trim(_.get(violation, "_"))
  let ruleset = _.get(violation, "$.ruleset")
  let rule = _.get(violation, "$.rule")
  let ruleinfo = ruleset && rule ? ` (${ruleset} :: ${rule})` : ""
  return `${msg}${ruleinfo}`
}

let into_vile_issues = (phpmd_files) =>
  _.flatten(
    _.map(phpmd_files, (file) =>
      _.map(file.violation, (violation) =>
        vile.issue(
          issue_type(violation),
          relative_path(file.$.name),
          message(violation),
          start_line(violation),
          end_line(violation)
        )
      )
    )
  )

let punish = (plugin_data) =>
  phpmd(plugin_data)
    .then(into_vile_issues)

module.exports = {
  punish: punish
}
