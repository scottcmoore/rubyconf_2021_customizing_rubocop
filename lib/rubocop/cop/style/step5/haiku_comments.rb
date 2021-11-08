# frozen_string_literal: true

require 'odyssey'
require 'pry'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        # It should match "a def node, that responds to `#poetic?` with true, with any number of args"
        def_node_matcher :poetic_method?, '(def #poetic? ...)'

        # It should match "a def node, of any name and with any args, with any children 
        # (use backtick and parens to search children), where the child is a send to any receiver with message puts with
        # args that are `#poetic_arg?`"
        # def_node_matcher :very_poetic_method?, <YOUR PATTERN HERE>

        # on_new_investigation will run at the beginning of our lint process
        def on_new_investigation
          define_syllable_counts
        end

        # Only runs on method definitions
        def on_def(node)
          # This will give us a hash like: `{ <AST> => [<Parser::Source::Comment>] }`
          node_with_comments = processed_source.ast_with_comments.select { |source_node, _comment| source_node == node }
          
          # We can just return if the node_with_comments is nil -- that just means we're currently
          # looking at a node without comments. For this workshop, we'll ignore those.
          return if node_with_comments.empty?

          return if node_with_comments.empty? # There wasn't a matching node in the ast_with_comments
          
          return unless poetic_method?(node) 

          # The first, and only, key will be our `node`.
          method_node = node_with_comments.keys.first
          # The first, and only, value will be our array of comments.
          comments = node_with_comments.values.first
          
          # Tag this node as failing the linting job.
          add_offense(method_node, message: message_for(method_node.method_name.to_s, comments)) unless comments.count == 3

          add_syllable_offenses(node, comments)
        end

        private

        # Is a method poetic, and therefore should have haiku comments?
        # This method can be called inside the node_pattern DSL.
        # You call this by _replacing_ the item in the pattern you want to 
        # pass to this method.
        # A 'poetic' method beings with 'poetic_'
        ########## not sure if you want this to be `arg` to be more general or `method_name`
        ########## but shhould be consistent across files.
        def poetic?(method_name)
          method_name.to_s.start_with? 'poetic_'
        end

        # Is this method really poetic, and therefore should have haiku comments?
        # This method can be called inside the node_pattern DSL.
        # You call this by _replacing_ the item in the pattern you want to 
        # pass to this method.
        # A really poetic method and contains a 'puts' with an argument 
        # including the string 'poet'?
        def poetic_arg?(arg)
          arg.to_s.include? 'poet'
        end

        def add_syllable_offenses(node, comments)
          syllables = []
          comments.each do |comment|
            syllables << syllables(comment&.text)
          end

          add_offense(node, message: message_for(node.method_name.to_s, comments)) unless syllables == [5, 7, 5]
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
