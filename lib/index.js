"use strict";

var path = require("path");
var Promise = require("bluebird");
var _ = require("lodash");
var xml = require("xml2js");
var vile = require("@brentlintner/vile");
var log = vile.logger.create("phpmd");

// TODO: break up this into smaller modules

var STARTING_SLASH = /^\//;
var PHPMD = "phpmd";
var XML_FORMAT = "xml";
var ALL_FILES = ".";
var DEFAULT_RULESETS = ["cleancode", "codesize", "controversial", "design", "naming", "unusedcode"];

var relative_path = function relative_path(file) {
  return path.isAbsolute(file) ? path.relative(process.cwd(), file) : file.replace(process.cwd().replace(STARTING_SLASH, ""), "").replace(STARTING_SLASH, "");
};

var xml_to_json = function xml_to_json(xml_string) {
  return new Promise(function (resolve, reject) {
    if (!xml_string) return resolve();
    xml.parseString(xml_string, function (err, json) {
      if (err) log.error(err);
      resolve(json);
    });
  });
};

var set_files = function set_files(data, opts) {
  var paths = _.get(data, "config.paths", ALL_FILES);
  if (paths.join) paths = paths.join(",");
  opts.push(paths);
};

var set_format = function set_format(data, opts) {
  return opts.push(XML_FORMAT);
};

var set_rulesets = function set_rulesets(data, opts) {
  var rulesets = _.get(data, "config.rulesets", DEFAULT_RULESETS);
  if (rulesets.join) rulesets = rulesets.join(",");
  opts.push(rulesets);
};

var set_suffixes = function set_suffixes(data, opts) {
  var suffixes = _.get(data, "config.suffixes");
  if (!suffixes) return;
  if (suffixes.join) suffixes = suffixes.join(",");
  opts.push("--suffixes", suffixes);
};

var set_exclude = function set_exclude(data, opts) {
  var exclude = _.get(data, "config.exclude");
  if (!exclude) return;
  if (exclude.join) exclude = exclude.join(",");
  opts.push("--exclude", exclude);
};

var set_option = function set_option(key, data, opts, fallback) {
  return _.has(data, "config." + key) ? opts.push("--" + key, _.get(data, "config." + key)) : fallback;
};

var set_flag = function set_flag(key, data, opts) {
  return _.has(data, "config." + key) ? opts.push("--" + key) : undefined;
};

var phpmd_args = function phpmd_args(data) {
  var args = [];

  set_files(data, args);
  set_format(data, args);
  set_rulesets(data, args);
  set_suffixes(data, args);
  set_exclude(data, args);
  set_option("minimumpriority", data, args);
  set_flag("strict", data, args);

  return args;
};

var phpmd = function phpmd(data) {
  return vile.spawn(PHPMD, { args: phpmd_args(data) }).then(xml_to_json).then(function (phpmd_result) {
    return _.get(phpmd_result, "pmd.file", []);
  });
};

var issue_type = function issue_type(violation) {
  return _.get(violation, "$.priority") == 1 ? vile.ERROR : vile.WARNING;
};

var start_line = function start_line(violation) {
  if (_.has(violation, "$.beginline")) {
    return { line: Number(violation.$.beginline) };
  }
};

var end_line = function end_line(violation) {
  if (_.has(violation, "$.endline")) {
    return { line: Number(violation.$.endline) };
  }
};

var message = function message(violation) {
  var msg = _.trim(_.get(violation, "_"));
  var ruleset = _.get(violation, "$.ruleset");
  var rule = _.get(violation, "$.rule");
  var ruleinfo = ruleset && rule ? " (" + ruleset + " :: " + rule + ")" : "";
  return "" + msg + ruleinfo;
};

var into_vile_issues = function into_vile_issues(phpmd_files) {
  return _.flatten(_.map(phpmd_files, function (file) {
    return _.map(file.violation, function (violation) {
      return vile.issue(issue_type(violation), relative_path(file.$.name), message(violation), start_line(violation), end_line(violation));
    });
  }));
};

var punish = function punish(plugin_data) {
  return phpmd(plugin_data).then(into_vile_issues);
};

module.exports = {
  punish: punish
};