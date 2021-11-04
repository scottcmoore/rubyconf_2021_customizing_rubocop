# Step-by-step instructions

These instructions are meant to guide you through building a custom Cop.

This workshop is broken up into steps.

We're going to focus on making small changes in each step. As we move from step to step, the starting point in each step will look like the ending point from the previous step. So you don't need to copy your changes over (unless you want to!), and you can just start each step fresh with the file found in `lib/rubocop/cop/style/step<number>/haiku_comments.rb`.

Each "step" is just a different directory to house your code.
"Switching steps" just means changing a path in `.rubocop.yml` to point to a different directory.

You can run `./switch_to_step.sh <a step number from 1-5>` to make this change.

You can see if your cop is running correctly by running `rubocop --debug app.rb`.

## Step 1
We're going to start with the following:
- Our "application" is a single file, app.rb. It prints some text -- exciting! You can run it with `ruby app.rb`.
- We have a mostly-default RuboCop setup in `.rubocop.yml`. We're ignoring the directories that house our custom cop. Normally you'd want to lint them too, but for the workshop we'll skip it. Feel free to enable this linting if you want!

Start Step 1 by running `rubocop --debug`. You should see a message including "no offenses detected". This is because your cop isn't doing anything! If you open `lib/rubocop/cop/style/step1/haiku_comments.rb` you'll see it's just an empty class.

For this step, we want to print the comments we find in the file, and exit. In order to do that, we're going to hook into one of RuboCop's callbacks.

RuboCop has several callbacks that get called in the course of a run, like:
- on_new_investigation: this gets called per-file, as RuboCop begins linting the file.
- on_send: this gets called as RuboCop parses a method call.

Right now, we want to just look at comments across the _entire_ file, so we can define an `on_new_investigation` method to hook into that callback.
Add some code to your Cop like:

```
def on_new_investigation
  # Do something to display comments
  # You might want to throw a `binding.pry` in here
end
```

Within `on_new_investigation`, we'll want to take a look at the AST that RuboCop has parsed from our source code.

A great way to see what is available to you from RuboCop is a debug statement (`binding.pry`) within `on_new_investigation`.

From there, we can examine `processed_source`, and in particular `processed_source.ast_with_comments`. This gives us a data structure of AST nodes, conveniently already associated with comments that are adjacent to them in the source.

See if you can get your Cop to print all comments from the file when you run `rubocop --debug app.rb`.

Once it does, you're ready for Step 2. Close your Step 1 file and open `lib/rubocop/style/step2/haiku_comments.rb`.

## Step 2
First run ` ./switch_to_step.sh 2` from the project root to point your `.rubocop.yml` to the Step 2 directory.

Now that we can see the comments for the whole file, let's look at comments associated with a node.
In particular, we're going to limit our linting only to method definitions.

In this step we're going to start using a different callback, `on_def`, which will run on each instance of `def` in the file. 

(Side note, `on_send` is another big one, and is run for all method calls.)

We can make some progress towards our linting goal here, by checking for methods with comments that aren't three lines.

If we get a node where the comment array associated with the node's AST doesn't have three elements, we should flag the node as being in violation. RuboCop will take care of pretty-printing the output for us.

Try to get your Cop to add offenses to any method definitions that have comments that are not three lines long. 
Once you reach that point, you are ready for Step 3. Close your Step 2 file and open `lib/rubocop/style/step3/haiku_comments.rb`.

## Step 3
First run ` ./switch_to_step.sh 3` from the project root to point your `.rubocop.yml` to the Step 3 directory.

Now that we are successfully enforcing that comments are three lines, we can use a gem called Odyssey to count syllables on each line.

The cop in the Step 4 directory has some helper methods for doing the syllable counting.
Update your Cop to add an offense to method nodes whose comments are not 5,7, and 5 syllables respectively.

Once you've done that, you're ready to move to Step 4. Close your Step 3 file and open `lib/rubocop/style/step4/haiku_comments.rb`.

## Step 4
First run ` ./switch_to_step.sh 4` from the project root to point your `.rubocop.yml` to the Step 4 directory.

Now we are enforcing that if methods have comments, those comments must be three lines of five, seven, and five syllables.
However, what if we only want to enforce that rule for certain types of methods?

Our app.rb has some methods that are poetic, which means that their method name starts with 'poetic_'

We are going to use RuboCop's [node pattern DSL](https://docs.rubocop.org/rubocop-ast/node_pattern.html) to limit which nodes we want to flag.
The node pattern DSL lets us define an AST pattern to match.

For example:
```
puts 'hello world'
```
Will be parsed into:
```
(send nil :puts (str "hello world"))
```
And we can write a node pattern that will match it.
```
(send _ :puts _)
```
The underscores represent "any single item". We can also name them more clearly:
```
(send _puts_receiver :puts _puts_argument)
```
In this example, `_receiver_of_puts` is `nil`, and `_argument_to_puts` is "hello world".

At this point in the workshop, rather than replicate the node pattern docs here, we're going to use [a fun tool](http://nodepattern.herokuapp.com/) to see some examples of the node pattern DSL, and to work towards one that will help us target poetic methods.

Although this really isn't the simplest way to examine a method's name, we're shoehorning it in here to demonstrate a simple node pattern.

The main difficulty here is going to be replacing the right item in the pattern with a call to our helper method.

Once you are only linting methods that start with poetic_, you're ready for Step 5.

You're ready for Step 5. Close your Step 4 file and open `lib/rubocop/style/step5/haiku_comments.rb`.

## Step 5

To dig into node patterns a bit more, we're going to match one more kind of poetic method in our cop. This time, we're looking for methods that contain a `puts` with an argument that contains the string 'poet'.

In order to match this, we're going to need to dig into the method body.

You can do so with:
```
 [0] [1]          [2]          [3]  [4] [5]            [6]   [7]
(def _method_name _method_arg1 `  ( send _puts_receiver :puts _puts_arg ) )
```
- 0 - a def node
- 1 - with any name
- 2 - with any single arg
- 3 - having anywhere in its descendants
- 4 - a send
- 5 - against any receiver
- 6 - of a `puts`
- 7 - with any single arg.

There are a couple things missing here though; one is that we aren't calling our helper method to determine if the method is poetic. The second is that this is fairly brittle and would only work for instances with single arguments. 

Take a shot at improving this node pattern. Once your cop lints methods that either:
- have a name staring with 'poetic_' or
- include a `puts` with an argument that contains 'poet'

You're done with the workshop! Thanks for much for reading this far!
