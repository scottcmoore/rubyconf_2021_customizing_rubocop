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

## Getting started
This workshop assumes that you have some experience writing Ruby.
This workshop does not assume that you have any experience with RuboCop.
This code has been tested with Ruby 2.6.5. # TODO: test with 3 once specs are written.

1. Clone the repo
1. Run the tests #TODO: write the tests!

## Learning objectives
This workshop will hopefully teach you:
1. What abstract syntax trees are and what they are useful for
1. How RuboCop uses ASTs to understand Ruby code
1. How to use RuboCop to enforce custom linting rules
1. Drawbacks to RuboCop
1. What is possible with RuboCop, and what isn't
1. (Time permitting,) How to 
