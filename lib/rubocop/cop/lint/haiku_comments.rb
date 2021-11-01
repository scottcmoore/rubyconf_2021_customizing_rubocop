# frozen_string_literal: true

require 'odyssey'

module RuboCop
  module Cop
    module Style
      # Custom Cop to enforce that all comments are in haiku format
      class HaikuComments < RuboCop::Cop::Cop
        def_node_matcher :poetic_method?, '(def #poetic? _ _)'

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

          return unless poetic_method? node

          node_name = node.method_name.to_s
          comments = node_with_comments.values.first

          # If there are no comments, we don't need to lint anything.
          return if comments.empty?

          return add_offense(node, message: message_for(node_name, comments)) unless comments.count == 3

          first_line = clean_text(comments[0].text)
          second_line = clean_text(comments[1].text)
          third_line = clean_text(comments[2].text)

          return add_offense(node, message: message_for(node_name, comments)) unless syllables(first_line) == 5 &&
                                                                                     syllables(second_line) == 7 &&
                                                                                     syllables(third_line) == 5
        end

        private

        def message_for(node_name, comments)
          comment_string = comments.reduce('') { |string, comment| "#{string}#{comment.text}\n" }
          <<~MESSAGE
            Comments for method `#{node_name}` must be in the form of a haiku.
            Please rewrite the following comments to be more poetic:
            #{comment_string}
          MESSAGE
        end

        def clean_text(text)
          text.gsub(/\W\s/, '')
        end

        def syllables(text)
          Odyssey.flesch_kincaid_re(text.downcase, all_stats: true)['syllable_count']
        end

        def poetic?(node_name)
          node_name.to_s.start_with? 'poet'
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
