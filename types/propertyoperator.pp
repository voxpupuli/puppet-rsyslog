# Enumerable custom type for rsyslog property operators
type Rsyslog::PropertyOperator = Enum[
  'contains',
  'isequal',
  'startswith',
  'endswith',
  'regex',
  'ereregex',
  '!contains',
  '!isequal',
  '!startswith',
  '!endswith',
  '!regex',
  '!ereregex',
]
