# frozen_string_literal: true

require 'pry'
  
module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        # Print all comments in the file and exit.
        def on_new_investigation
          processed_source.ast_with_comments.each_value.map do |comments|
            puts comments.map(&:text)
          end
        end

        # This callback will be called on all instances of `def` -- i.e., it will
        # be called for all method definitions.
        def on_def(node)
          # TODO: First, print the node name (the name of the defined method). The node should
          # have a method_name method.

          # TODO: Get the AST with comments for the node we're currently linting.
          # We still have access to `processed_source.ast_with_comments` here, so we
          # can grab the `ast_with_comments` just for the node being checked, by `select`ing from the
          # AST where the AST node is the node being linted.

          # This will give us a hash like: `{ <AST> => [<Parser::Source::Comment>] }`
          # The first, and only, key will be our `node`.
          # The first, and only, value will be our array of comments.

          # TODO: We should just return if the node_with_comments is empty -- that just means we're currently
          # looking at a node without comments. For this workshop, we'll ignore those.

          # TODO: Second, add an offense if the method definition doesn't have three comment lines.
          # Adding an offense is just `add_offense(node, message: "a helpful message")`.
          # RuboCop will handle the rest.
        end
      end
    end
  end
end
