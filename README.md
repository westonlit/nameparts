nameparts
=========
[![Build Status](https://travis-ci.org/Ghary/nameparts.svg)](https://travis-ci.org/Ghary/nameparts)

nameparts is port to NodeJS module from a Python module written by [James Polera!](https://github.com/polera) to
address a problem splitting full names into individual parts (first, middle, last, etc.).

You can use it like this:
        > var NameParts = require('./lib/NameParts.js');
        > var parts = NameParts.parse('Bruce Wayne a/k/a Batman');
        > parts.firstName;
        'Bruce'
        > parts.lastName;
        'Wayne'
        > parts.aliases[0];
        'Batman'

Installing
----------
       npm install NameParts

License
-------
nameparts is released under the BSD license.
