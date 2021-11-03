# Step-by-step instructions

These instructions are meant to guide you through building a custom Cop.
Each "step" is just a different directory to house your code.
We'll switch steps by changing `.rubocop.yml` to point to the appropriate directory.

You can run `./switch_to_step.sh <a step number from 1-6>` to make this change.

You can see if your cop is running correctly by running `rubocop --debug app.rb`.

After Step 1, you can run just your custom Cop with `rubocop --only Style/HaikuComments app.rb`.

## Step 1
We're going to start by creating a custom Cop that just runs and exits successfully.
This is going to be defined in `lib/rubocop/cop/style/step1/haiku_comments.rb`.

Begin by running `rubocop --debug app.rb`.

You should get an error like "cannot load such file -- " followed by a path ending with `lib/rubocop/cop/style/step1/haiku_comments.rb`.

If you look in your RuboCop configuration, you'll see that we're `require`ing that path.
Create an empty file called `haiku_comments.rb` at that path.

Running `rubocop --debug app.rb` should now succeed -- it's time to move to step 2.

## Step 2
First run `./switch_to_step.sh 2` from the project root to point your `.rubocop.yml` to the Step 2 directory.

In this step, we're going to use a method RuboCop provides to print comments in the file.
RuboCop has several callbacks that get called in the course of a run, like:
- on_new_investigation: this gets called per-file, as RuboCop begins linting the file.
- on_send: this gets called as RuboCop parses a method call.

Right now, we want to just look at comments across the entire file, so we can extend `on_new_investigation`.
Add some code to your Cop like:

```
def on_new_investigation
  # Do something to display comments
end
```

Within `on_new_investigation`, we'll want to take a look at the AST that RuboCop has parsed from our source code.

A great way to see what is available to you from RuboCop is a debug statement (`binding.pry`) within `on_new_investigation`.

From there, we can examine `processed_source`, and in particular `processed_source.ast_with_comments`.
See if you can get your Cop to print all comments from the file when you run `rubocop --debug app.rb`.
Once it does, you're ready for Step 3.

## Step 3
First run ` ./switch_to_step.sh 3` from the project root to point your `.rubocop.yml` to the Step 3 directory.

Now that we can see the comments for the whole file, let's look at comments associated with a node.
In particular, we're going to limit our linting only to method definitions.

In this step we're going to start using a different callback, `on_def`, which will run on each instance of `def` in the file. 

(Side note, `on_send` is another big one, and is run for all method calls.)

This will let us examine each method definition in turn.
We still have access to `processed_source.ast_with_comments` here, so we can grab the `ast_with_comments` just for the node being checked:
```
node_with_comments = processed_source.ast_with_comments.select { |source_node, _comment| source_node == node }
```

This will give us a hash like: `{ <AST> => [<Parser::Source::Comment>] }`
We can make some progress towards our linting goal here, by checking for methods with comments that aren't three lines.

If we get a node where the comment array associated with the node's AST doesn't have three elements, we should flag the node as being in violation.

Adding an offense for a node is simple:

```
add_offense(node, message: "a message to the developer")

```

If we pass the node and the message, RuboCop will take care of pretty-printing the output for us.

Try to get your Cop to add offenses to any method definitions that have comments that are not three lines long.
Once you reach that point, you are ready for Step 4.

## Step 4
First run ` ./switch_to_step.sh 4` from the project root to point your `.rubocop.yml` to the Step 4 directory.

Now that we are successfully enforcing that comments are three lines, we can use a gem called Odyssey to count syllables on each line.

The cop in the Step 4 directory has some helper methods for doing the syllable counting.
Update your Cop to add an offense to method nodes whose comments are not 5,7, and 5 syllables respectively.

Once you've done that, you're ready to move to Step 5.

## Step 5
First run ` ./switch_to_step.sh 5` from the project root to point your `.rubocop.yml` to the Step 5 directory.

Now we are enforcing that if methods have comments, those comments must be three lines of five, seven, and five syllables.
However, what if we only want to enforce that rule for certain types of methods?
Our app.rb has some methods that are poetic, which (of course) means that they call `puts` with an argument containing the string 'poet'.

We can see in app.rb that `execute` is the only poetic method so far.
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
We can use underscores to indicate that we want our pattern to accept any single node:
```
(send _receiver_of_puts :puts _argument_to_puts)
```
In this example, `_receiver_of_puts` is `nil`, and `_argument_to_puts` is "hello world".

At this point in the workshop, rather than replicate the node pattern docs here, we're going to use [a fun tool](http://nodepattern.herokuapp.com/) to see some examples of the node pattern DSL, and to work towards one that will help us target poetic methods.
Remember that a poetic method is one that calls `puts` with a string that includes "poet".

## Step 6

Step 6 is still TBD, depending on how much time we have we might look into autocorrection or configuration options.