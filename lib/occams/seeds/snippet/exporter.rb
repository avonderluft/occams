# frozen_string_literal: true

module Occams::Seeds::Snippet
  class Exporter < Occams::Seeds::Exporter
    def initialize(from, to = from)
      super
      self.path = ::File.join(Occams.config.seeds_path, to, 'snippets/')
    end

    def export!
      prepare_folder!(path)

      site.snippets.each do |snippet|
        attrs = {
          'label' => snippet.label,
          'categories' => snippet.categories.map(&:label),
          'position' => snippet.position
        }.to_yaml

        data = []
        data << { header: 'attributes', content: attrs }
        data << { header: 'content', content: snippet.content }

        snippet_path = File.join(path, "#{snippet.identifier}.html")
        write_file_content(snippet_path, data)

        message = "[CMS SEEDS] Exported Snippet \t #{snippet.identifier}"
        Occams.logger.info(message)
      end
    end
  end
end
