# frozen_string_literal: true

require 'odyssey'
require 'pry'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        # TODO: define a node matcher that calls #poetic?

        # on_new_investigation will run at the beginning of our lint process
        def on_new_investigation
          define_syllable_counts
        end

        # Only runs on method definitions
        def on_def(node)
          # Commented source is a hash like:
          # { <AST> => [<Parser::Source::Comment>]}
          # Importantly, it will _only_ include the portion of the AST that has comments
          node_with_comments = processed_source.ast_with_comments.select { |source_node, _comment| source_node == node }
          node = node_with_comments.keys.first

          # There wasn't a matching node in the ast_with_comments
          return if node.nil?

          # TODO: skip this node if our node matcher
          return unless poetic_method? node

          node_name = node.method_name.to_s
          comments = node_with_comments.values.first

          return add_offense(node, message: message_for(node_name, comments)) unless comments.count == 3

          add_syllable_offenses(node_name, comments)
        end

        private

        # Is a method poetic, and therefore should have haiku comments?
        # This predicate method can be called inside the node_pattern DSL.
        # A "poetic" method is one that includes 'puts' with an argument including the string 'poet'
        def poetic?(arg)
          arg.to_s.include? 'poet'
        end

        def add_syllable_offenses(node_name, comments)
          syllables = []
          comments.each do |comment|
            syllables << syllables(comment&.text)
          end

          add_offense(node, message: message_for(node_name, comments)) unless syllables == [5, 7, 5]
        end

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
