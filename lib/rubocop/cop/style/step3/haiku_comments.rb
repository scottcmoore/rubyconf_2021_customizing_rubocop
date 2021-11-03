# frozen_string_literal: true

require 'pry'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        # Print all comments in the file and exit.
        def on_new_investigation
          processed_source.ast_with_comments.values.first.each do |comment|
            puts comment.text
          end
        end

        # This callback will be called on all instances of `def` -- i.e., it will
        # be called for all method definitions.
        def on_def(node)
          # TODO: First, print the node name (the name of the defined method) and any comments associated with it.
          # TODO: Second, add an offense if the method definition doesn't have three comment lines.
        end
      end
    end
  end
end
