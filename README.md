nameparts
=========
[![Build Status](https://travis-ci.org/Ghary/nameparts.svg)](https://travis-ci.org/Ghary/nameparts)

nameparts is a code port from a Python project to NodeJS. The original Python module written by
[James Polera](https://github.com/polera) to address the problem of having to split full names into
individual parts (first, middle, last, etc.).

To use this module:
```
> var NameParts = require('nameparts');
> var parts = NameParts.parse('Bruce Wayne a/k/a Batman');
> parts.firstName;
'Bruce'
> parts.lastName;
'Wayne'
> parts.aliases[0];
'Batman'
```

Installing
----------
```
npm install nameparts
```

License
-------
nameparts is released under the BSD license.
