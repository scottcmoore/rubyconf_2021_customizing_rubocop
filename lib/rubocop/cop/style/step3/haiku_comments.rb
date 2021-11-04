# frozen_string_literal: true

require 'odyssey'
require 'pry'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        def on_new_investigation
          # This is not an important part of the workshop!
          # Normally you'd probably want to do setup like this at a higher level than a single Cop,
          # but for the workshop we'll use this callback to do some quick hackery on our syllable
          # counting library.
          define_syllable_counts
        end

        # This callback will be called on all instances of `def` -- i.e., it will
        # be called for all method definitions.
        def on_def(node)
          puts "Linting #{node.method_name}..."
          
          # This will give us a hash like: `{ <AST> => [<Parser::Source::Comment>] }`
          node_with_comments = processed_source.ast_with_comments.select { |source_node, _comment| source_node == node }
          
          # We can just return if the node_with_comments is nil -- that just means we're currently
          # looking at a node without comments. For this workshop, we'll ignore those.
          return if node_with_comments.empty?

          # The first, and only, key will be our `node`.
          method_node = node_with_comments.keys.first
          # The first, and only, value will be our array of comments.
          comments = node_with_comments.values.first

          # Tag this node as failing the linting job.
          add_offense(method_node, message: message_for(method_node.method_name.to_s, comments)) unless comments.count == 3

          # TODO: Add an offense if the comments don't have 5, 7, and 5 syllables respectively.
          # Each item in the comments array should respond to `text`; we can use the `syllables` private
          # method to count syllables in the text.
        end

        private

        # Print a message that helps the developer fix their code
        def message_for(node_name, comments)
          comment_string = comments.reduce('') { |string, comment| "#{string}#{comment.text}\n" }
          <<~MESSAGE
            Comments for method `#{node_name}` must be in the form of a haiku.
            Please rewrite the following comments to be more poetic:
            #{comment_string}
          MESSAGE
        end

        # Clean up a comment string to remove non-word characters like spaces and '#'.
        def clean_text(text)
          text.gsub(/\W\s/, '')
        end

        # Return the count of syllables in a string.
        def syllables(text)
          Odyssey.flesch_kincaid_re(clean_text(text).downcase, all_stats: true)['syllable_count']
        end

        # Odyssey doesn't always calculate syllables correctly, so we can
        # hardcode in some words if needed, just as a workaround for the workshop.
        def define_syllable_counts
          Odyssey::Engine::PROBLEM_WORDS.merge!({ 'doing' => 2 })
        end
      end
    end
  end
end
