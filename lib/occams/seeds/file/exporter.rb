# frozen_string_literal: true

module Occams::Seeds::File
  class Exporter < Occams::Seeds::Exporter
    def initialize(from, to = from)
      super
      self.path = ::File.join(Occams.config.seeds_path, to, 'files/')
    end

    def export!
      prepare_folder!(path)

      site.files.each do |file|
        file_path = File.join(path, file.attachment.filename.to_s)

        # writing attributes
        ::File.write(::File.join(path, "_#{file.attachment.filename}.yml"), {
          'label' => file.label,
          'description' => file.description,
          'categories' => file.categories.map(&:label)
        }.to_yaml)

        # writing content
        begin
          ::File.binwrite(::File.join(path, ::File.basename(file_path)), file.attachment.download)
          Occams.logger.info("[CMS SEEDS] Exported File \t #{file.attachment.filename}")
        rescue Errno::ENOENT, OpenURI::HTTPError
          Occams.logger.warn("[CMS SEEDS] No physical File \t #{file.attachment.filename}")
        end
      end
    end
  end
end
