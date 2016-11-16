Promise = require "bluebird"
phpmd_xml = require "./../fixtures/phpmd-xml"

setup = (vile) ->
  vile.spawn.returns new Promise (resolve) ->
    resolve({ code: 0, stdout: phpmd_xml, stderr: "" })

issues = [
  {
    path: "relative-path/file.php",
    type: "style",
    title: "some violation",
    message: "some violation",
    advisory: undefined,
    signature: "phpmd::some violation",
    where: { start: { line: 0 }, end: undefined }
  },
  {
    path: "absolute-path/file.php",
    type: "style",
    title: "some violation",
    message: "some violation",
    advisory: undefined,
    signature: "phpmd::some violation",
    where: { start: { line: 0 }, end: undefined }
  },
  {
    path: "test/fixtures/UserController.php",
    type: "maintainability",
    advisory: "#",
    title: "login accesses the super-global variable $_POST." +
          " (Controversial Rules :: Superglobals)",
    message: "login accesses the super-global variable $_POST." +
          " (Controversial Rules :: Superglobals)",
    signature: "phpmd::Controversial Rules::Superglobals",
    where: { start: { line: 11 }, end: undefined }
  },
  {
    path: "test/fixtures/UserController.php",
    type: "style",
    advisory: "http://phpmd.org/rules/naming.html#shortvariable",
    title: "Avoid variables with short names like $id. " +
          "Configured minimum length is 3.",
    message: "Avoid variables with short names like $id. " +
          "Configured minimum length is 3.",
    signature: "phpmd::Naming Rules::undefined",
    where: undefined
  },
  {
    path: "test/fixtures/UserController.php",
    type: "maintainability",
    advisory: "http://phpmd.org/rules/cleancode.html#eleseexpression",
    title: "The method login uses an else expression. " +
          "Else is never necessary and you can simplify the code to " +
          "work without else. (Clean Code Rules :: ElseExpression)",
    message: "The method login uses an else expression. " +
          "Else is never necessary and you can simplify the code to " +
          "work without else. (Clean Code Rules :: ElseExpression)",
    signature: "phpmd::Clean Code Rules::ElseExpression",
    where: { start: { line: 23 }, end: { line: 47 } }
  }
]

module.exports =
  issues: issues
  setup: setup
