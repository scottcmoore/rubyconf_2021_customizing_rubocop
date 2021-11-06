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

          ########### Thinking it makes sense to associate your explanations below with
          ########### explicit TODO's. I interpreted this as needing 
          ########### to do 2 things (print the node name and add an offense), but there
          ########### are some intermediate steps as well. Something like....
          ########### TODO: Grab the ast_with_comments and assign it to a variable
          ########### TODO: Bail out if the node_with_comments is empty
          ########### TODO: Assign the node and array of comments to variables
          ########### This could also be a bit overkill, so an alternative would be to remove 
          ########### the first TODO and just leave the whole TODO as just "add an offense..."
          ########### I'm sort of in favor of pseudocode TODOs associated with your explanations.
          
          # We still have access to `processed_source.ast_with_comments` here, so we 
          # can grab the `ast_with_comments` just for the node being checked:
          # node_with_comments = processed_source.ast_with_comments.select { |source_node, _comment| source_node == node }
          # We can just return if the node_with_comments is nil -- that just means we're currently
          # looking at a node without comments. For this workshop, we'll ignore those.

          # This will give us a hash like: `{ <AST> => [<Parser::Source::Comment>] }`
          # The first, and only, key will be our `node`.
          # The first, and only, value will be our array of comments.

          # TODO: Second, add an offense if the method definition doesn't have three comment lines.
          # Adding an offense is just `add_offense(node, message: "a helpful message")`.
          # RuboCop will handle the rest.
        end
      end
    end
  end
end
