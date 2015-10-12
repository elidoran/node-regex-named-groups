# regex-named-groups
[![Build Status](https://travis-ci.org/elidoran/node-regex-named-groups.svg?branch=master)](https://travis-ci.org/elidoran/node-regex-named-groups)
[![Dependency Status](https://gemnasium.com/elidoran/node-regex-named-groups.png)](https://gemnasium.com/elidoran/node-regex-named-groups)
[![npm version](https://badge.fury.io/js/regex-named-groups.svg)](http://badge.fury.io/js/regex-named-groups)

Enhances the `exec()` function to provide a result with named properties for capture groups.

## Install

```sh
npm install regex-named-groups --save
```

## Usage


```coffeescript
# get this module
captureNames = require 'regex-named-groups'

# build a regular expression with capture groups
# groups you don't want should be ignored with ?:
regex = /(1st group) blah (2nd (?:g|G)oup) (?:ignored group) (3rd group)/

# the capture names in order. their indices are mapped, plus 1, to result indices
names = ['first', 'second', 'third']

# enhance the regex instance with capture names
enhancedRegex = captureNames regex, names

# test string:
string1 = '1st group blah 2nd group ignored group 3rd group'

# run exec on a string
result = enhancedRegex.exec string1

# result has the capture groups mapped to their names
result.first  = '1st group' # was result[1]
result.second = '2nd group' # was result[2]
result.third  = '3rd group' # was result[3]

# to preserve array result specify `preserve` in options object
enhancedRegex = captureNames regex, names, preserve:true
# OR: put all of them in an options object:
enhancedRegex = captureNames
  regex:regex
  names:names
  preserve:true # preserves the usual array returned by exec()

# the key is prefixed with a dollar sign to avoid name conflicts
result.$array = # the usual result returned by exec()
```

## MIT License
