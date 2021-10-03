# README

This is a rough plan for a RubyConf 2021 workshop called "All Comments Must Be Haiku".
The goal of this workshop is for participants to understand how to write custom RuboCop Cops.


## Core Goals
1. Explain syntax trees, with simple examples and possible applications
1. Explain RuboCop, pros and cons, general design
1. Step-by-step coding exercise to write a custom cop


## Stretch goals
1. Ask what else syntax trees might be used for
1. Discuss underlying parser gem
1. Ask what might _not_ be possible with RuboCop
1. Discuss Standard Ruby
1. Automatically run or apply RuboCop against git commits with commit hooks
1. Discuss what's possible with autocorrect in our case
1. Implement configuration for multiple enforcement schemes (https://en.wikipedia.org/wiki/Tanka)

## Topics to get more background on
1. ASTs
1. RuboCop node patterns
1. parser gem
1. https://github.com/cameronsutter/odyssey

### Coding exercise
Ideally this should be multiple steps, so that if a participant gets stuck on a certain point, they can skip ahead to the next step.
To be really fancy, we could write tests against the new Cop in order to help participants check their solutions.
This might take more time than we have though.
Some kind of process or script for switching between steps would be another nice-to-have.

The steps might look like:

1. Write a cop that runs and returns sucess
1. Update it to read comments and do something (success? failure? print and exit?)
1. Limit cop to method comments
1. Enforce that method comments are only three lines
1. Enforce that method comments are 5-7-5


## TODO

1. Write AST examples and add to slides
1. Write RuboCop overview and add to slides
1. Create new app and push with initial RuboCop default config
1. Code custom cop
1. Break complete cop into "steps" directories