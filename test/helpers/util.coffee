Promise = require "bluebird"
phpmd_xml = require "./../fixtures/phpmd-xml"

setup = (vile) ->
  vile.spawn.returns new Promise (resolve) ->
    resolve(phpmd_xml)

issues = [
  {
    file: "test/fixtures/UserController.php",
    msg: "login accesses the super-global variable $_POST." +
          " (Controversial Rules :: Superglobals)",
    type: "error",
    where: { start: { line: 11 }, end: {} },
    data: {}
  },
  {
    file: "test/fixtures/UserController.php",
    msg: "Avoid variables with short names like $id. " +
          "Configured minimum length is 3.",
    type: "warn",
    where: { start: {}, end: {} },
    data: {}
  },
  {
    file: "test/fixtures/UserController.php",
    msg: "The method login uses an else expression. " +
          "Else is never necessary and you can simplify the code to " +
          "work without else. (Clean Code Rules :: ElseExpression)",
    type: "error",
    where: { start: { line: 23 }, end: { line: 47 } },
    data: {}
  }
]

module.exports =
  issues: issues
  setup: setup
