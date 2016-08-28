mimus = require "mimus"
phpmd = mimus.require "./../lib", __dirname, []
chai = require "./helpers/sinon_chai"
util = require "./helpers/util"
vile = mimus.get phpmd, "vile"
log = mimus.get phpmd, "log"
xml2js = mimus.get phpmd, "xml"
expect = chai.expect

DEFAULT_PHPMD_RULESETS = [
  "cleancode",
  "codesize",
  "controversial",
  "design",
  "naming",
  "unusedcode"
].join ","

DEFAULT_ARGS = [
  ".",
  "xml",
  DEFAULT_PHPMD_RULESETS
]

# TODO: write integration tests for spawn -> cli
# TODO: don't use setTimeout everywhere (for proper exception throwing)
# TODO: ensure flags and commands are called in proper order

expect_to_set_args = (done, spawn_args, plugin_data) ->
  phpmd
    .punish plugin_data || {}
    .should.be.fulfilled.notify ->
      setTimeout ->
        vile.spawn.should.have.been
          .calledWith "phpmd", spawn_args || { args: DEFAULT_ARGS }
          done()
      , 10
  return

describe "phpmd", ->
  afterEach mimus.reset
  after mimus.restore
  beforeEach ->
    mimus.stub log, "error"
    mimus.stub vile, "spawn"
    util.setup vile

  describe "#punish", ->
    it "converts phpmd xml to issues", ->
      phpmd
        .punish {}
        .should.eventually.eql util.issues

    it "handles an empty response", ->
      vile.spawn.reset()
      vile.spawn.returns new Promise (resolve) -> resolve ""

      phpmd
        .punish {}
        .should.eventually.eql []

    it "sets the cli output format to xml", (done) ->
      expect_to_set_args done

    describe "when there xml parse error", ->
      error = new Error "cli call had an error"

      beforeEach ->
        mimus.stub xml2js, "parseString"
        xml2js.parseString.callsArgWith 1, error

      afterEach ->
        xml2js.parseString.restore()

      it "logs an error and fulfills promise", (done) ->
        phpmd
          .punish {}
          .should.be.fulfilled.notify ->
            setTimeout ->
              log.error.should.have.been.calledWith error
              done()
            , 10
        return

    describe "file paths", ->
      describe "when given a single path", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: ["a/**/*.php", "xml", DEFAULT_PHPMD_RULESETS] },
            { config: paths: "a/**/*.php" }
          )

      describe "when given multiple paths", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: ["a.php,b/**", "xml", DEFAULT_PHPMD_RULESETS] },
            { config: paths: ["a.php", "b/**"] }
          )

    describe "rulesets", ->
      describe "when given a single value", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: [".", "xml", "ruleset"] },
            { config: rulesets: "ruleset" }
          )

      describe "when given multiple values", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: [".", "xml", "ruleset1,ruleset2"] },
            { config: rulesets: [ "ruleset1", "ruleset2" ] }
          )

      describe "when not given", ->
        it "sets to all currently known rulesets", (done) ->
          expect_to_set_args(
            done,
            {
              args: [
                ".",
                "xml"
                "cleancode,codesize,controversial," +
                "design,naming,unusedcode"
              ]
            }
          )

    describe "suffixes", ->
      describe "when given a single path", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: DEFAULT_ARGS.concat ["--suffixes", "a"] },
            config: suffixes: "a"
          )

      describe "when given multiple paths", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: DEFAULT_ARGS.concat ["--suffixes", "a,b"] },
            { config: suffixes: ["a", "b"] }
          )

    describe "exclude", ->
      describe "when given a single path", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: DEFAULT_ARGS.concat ["--exclude", "a/**"] },
            { config: exclude: "a/**" }
          )

      describe "when given multiple paths", ->
        it "sets the related option", (done) ->
          expect_to_set_args(
            done,
            { args: DEFAULT_ARGS.concat ["--exclude", "a/**,b.php"] },
            { config: exclude: [ "a/**", "b.php" ] }
          )

    describe "minimumpriority", ->
      it "sets the related option", (done) ->
        expect_to_set_args(
          done,
          { args: DEFAULT_ARGS.concat ["--minimumpriority", 1] },
          { config: minimumpriority: 1 }
        )

    describe "strict", ->
      it "sets the related boolean option", (done) ->
        expect_to_set_args(
          done,
          { args: DEFAULT_ARGS.concat ["--strict"] },
          { config: strict: true }
        )
