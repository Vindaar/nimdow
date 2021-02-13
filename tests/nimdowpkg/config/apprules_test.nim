import
  config/apprules,
  parsetoml

test "valid single app rule":
  let testToml: string = """
  [[appRule]]
  class = "Element"
  instance = "element"
  monitor = 2
  tags = [ 1, 9 ]
  """

  let toml = parseString(testToml)
  let rules: seq[AppRule] = parseTable(toml.tableVal)

  let firstRule = rules[0]
  doAssert firstRule.class == "Element"
  doAssert firstRule.instance == "element"
  doAssert firstRule.monitorID == 2.Positive
  doAssert firstRule.tagIDs == @[ 1.Positive, 9 ]

test "valid multiple app rules":
  let testToml: string = """
  [[appRule]]
  class = "Element"
  instance = "element"
  monitor = 2
  tags = [ 1, 9 ]

  [[appRule]]
  class = "st"
  instance = "st"
  monitor = 1
  tags = [ 3, 7, 8 ]
  """

  let toml = parseString(testToml)
  let rules: seq[AppRule] = parseTable(toml.tableVal)

  assert rules.len == 2

  let firstRule = rules[0]
  doAssert firstRule.class == "Element"
  doAssert firstRule.instance == "element"
  doAssert firstRule.monitorID == 2.Positive
  doAssert firstRule.tagIDs == @[ 1.Positive, 9 ]

  let secondRule = rules[1]
  doAssert secondRule.class == "st"
  doAssert secondRule.instance == "st"
  doAssert secondRule.monitorID == 1.Positive
  doAssert secondRule.tagIDs == @[ 3.Positive, 7, 8 ]

test "no app rules does not raise an exception":
  let testToml: string = ""

  let toml = parseString(testToml)
  let rules: seq[AppRule] = parseTable(toml.tableVal)
  assert rules.len == 0

test "has an invalid class":
  let testToml: string = """
  [[appRule]]
  class = 123
  instance = "element"
  monitor = 2
  tags = [ 1, 9 ]
  """

  let toml = parseString(testToml)
  assertRaises(Exception, "class must be a string!"):
    discard parseTable(toml.tableVal)

test "has an invalid instance":
  let testToml: string = """
  [[appRule]]
  class = "Element"
  instance = 142
  monitor = 2
  tags = [ 1, 9 ]
  """

  let toml = parseString(testToml)
  assertRaises(Exception, "instance must be a string!"):
    discard parseTable(toml.tableVal)

test "has an invalid monitor":
  let testToml: string = """
  [[appRule]]
  class = "Element"
  instance = "element"
  monitor = "2"
  tags = [ 1, 9 ]
  """

  let toml = parseString(testToml)
  assertRaises(Exception, "monitor must be an integer!"):
    discard parseTable(toml.tableVal)

test "has an invalid tags array":
  let testToml: string = """
  [[appRule]]
  class = "Element"
  instance = "element"
  monitor = 2
  tags = 1
  """

  let toml = parseString(testToml)
  assertRaises(Exception, "tags must be an array!"):
    discard parseTable(toml.tableVal)

