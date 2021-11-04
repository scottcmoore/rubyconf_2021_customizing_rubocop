# frozen_string_literal: true

require 'pry'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        # TODO: Print out the comments and exit.
        # We want to hook into the `on_new_investigation` callback, so that we can run
        # once when RuboCop begins linting each file.

        # In that method, we want to take a look at the processed_source.ast_with_comments
        # that RuboCop provides us.
        # Use `binding.pry` to explore the data structure we get from that. Look around at
        # the rest of processed_source too!
        
        # To get all the comments, you'll want just the values from the ast_with_comments,
        # and each of those will be an array of Parser::Source::Comments which will respond
        # to `.text` and provide the comment's text.
      end
    end
  end
end
