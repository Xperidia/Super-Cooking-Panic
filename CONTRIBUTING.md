# Contributing to Super Cooking Panic

The following is a set of guidelines for contributing to Super Cooking Panic. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

[Styleguides](#styleguides)

* [Git Commit Messages](#git-commit-messages)
* [GLua Styleguide](#glua-styleguide)

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")

### GLua Styleguide

* Your code should not make errors or warnings with [GLuaFixer](https://github.com/FPtje/GLuaFixer).
* Always test your code and make sure it doesn't make any error in game.
* Always prefer native Lua operators. Do not use [gmod's custom operators aliases](https://wiki.facepunch.com/gmod/Specific_Operators).
