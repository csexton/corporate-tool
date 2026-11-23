require 'kramdown'
require 'kramdown/converter/syntax_highlighter/rouge'

module Kramdown
  module Options
    define(:enable_mermaid, Boolean, true, "Enable Mermaid wrapped Rouge SyntaxHighlighting")
  end

  module Converter #:nodoc:
    module SyntaxHighlighter #:nodoc:
      module MermaidRouge
        extend ::Kramdown::Utils::Configurable

        VERSION = '0.0.1'

        def self.call(converter, text, lang, type, call_opts)
          return nil unless converter.options[:enable_mermaid]
          if lang && lang == "mermaid"
            # Escaped so the diagram source can't inject markup; mermaid reads
            # the element's textContent, so entities decode back to the source.
            "<div class=\"mermaid\">\n" << CGI.escapeHTML(text) << "\n</div>"
          else
            SyntaxHighlighter::Rouge.call(converter, text, lang, type, call_opts)
          end
        rescue StandardError
          converter.warning("There was an error using Mermaid or Rouge: #{$!.message}")
          "<div class='alert alert-warning'>#{ CGI.escapeHTML($!.message) }</div>"
        end

        def self.options(converter, type)
          nil
        end
      end

    end
    add_syntax_highlighter(:mermaid_rouge, SyntaxHighlighter::MermaidRouge)
  end
end

