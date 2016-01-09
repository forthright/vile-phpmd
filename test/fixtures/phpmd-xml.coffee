module.exports = """
<?xml version="1.0" encoding="UTF-8" ?>
<pmd version="@project.version@" timestamp="2016-01-07T23:09:10+00:00">
  <file name="/home/brent/src/vile/plugins/phpmd/test/fixtures/NoViolations.php">
  </file>
  <file name="/home/brent/src/vile/plugins/phpmd/test/fixtures/UserController.php">
    <violation beginline="11" rule="Superglobals" ruleset="Controversial Rules" package="+global" externalInfoUrl="#" class="UserController" method="login" priority="1">
      login accesses the super-global variable $_POST.
    </violation>
    <violation ruleset="Naming Rules" externalInfoUrl="http://phpmd.org/rules/naming.html#shortvariable" priority="3">
      Avoid variables with short names like $id. Configured minimum length is 3.
    </violation>
    <violation beginline="23" endline="47" rule="ElseExpression" ruleset="Clean Code Rules" externalInfoUrl="http://phpmd.org/rules/cleancode.html#eleseexpression" priority="1">
      The method login uses an else expression. Else is never necessary and you can simplify the code to work without else.
    </violation>
  </file>
</pmd>
"""
