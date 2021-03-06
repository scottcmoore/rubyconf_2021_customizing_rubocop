# README

This repository contains code and documentation for a RubyConf 2021 workshop called "All Comments Must Be Haiku! Custom linting with RuboCop".
In this workshop, we will:
- Discuss RuboCop, what it does, its benefits and drawbacks.
- Experiment a little with [parser](https://github.com/whitequark/parser) and learn about the underlying data structure RuboCop uses to parse code.
- Write a custom cop (linting rule) that will enforce a rule that comments must be in haiku format.
- Extend that cop in order to get more practice with RuboCop's Node Pattern DSL

If time permits we will:
- Add auto-correction to our cop
- Add [configuration options](https://en.wikipedia.org/wiki/Tanka) to our cop

## Prerequisites
This workshop assumes that you have some experience writing Ruby.
This workshop does not assume that you have any experience with RuboCop.

## Getting Ready
You'll need Ruby installed.
This code has been tested with Ruby 2.5, 2.6, and 3.0.

### Set up the workshop app
1. Clone the repo
1. Run `bundle install`

## Learning objectives
This workshop will hopefully teach you:
1. What abstract syntax trees are and what they are useful for
1. How RuboCop uses ASTs to understand Ruby code
1. How to use RuboCop to enforce custom linting rules
1. Drawbacks to RuboCop
1. What is possible with RuboCop, and what isn't


## Resources

These are some links to useful reading about some of the topics we've touched on.

- [parser, the library RuboCop uses to get the AST](https://github.com/whitequark/parser)
- [a great evilmartians blog post, has links to examples of cops from many teams](https://evilmartians.com/chronicles/custom-cops-for-rubocop-an-emergency-service-for-your-codebase)
- [node pattern debugger](https://github.com/marcandre/np)
- [ast explorer, another cool interactive AST tool but unfortunately no Ruby support](https://astexplorer.net/)
