# frozen_string_literal: true

module Occams::Seeds::File
  class Importer < Occams::Seeds::Importer
    def initialize(from, to = from)
      super
      self.path = ::File.join(Occams.config.seeds_path, from, 'files/')
    end

    def import!
      Dir["#{path}[^_]*"].each do |file_path|
        filename = ::File.basename(file_path)

        file = site.files.with_attached_attachment
          .where('active_storage_blobs.filename' => filename).references(:blob).first ||
               site.files.new

        # We need to track actual file and its attributes
        fresh_file = false

        if File.exist?(attrs_path = File.join(path, "_#{filename}.yml")) && fresh_seed?(file, attrs_path)
          fresh_file = true

          attrs = YAML.safe_load(File.read(attrs_path))
          category_ids = category_names_to_ids(file, attrs.delete('categories'))
          file.attributes = attrs.merge(
            category_ids: category_ids
          )
        end

        if fresh_seed?(file, file_path)
          fresh_file = true

          file_handler = File.open(file_path)
          file.file = {
            io: file_handler,
            filename: filename,
            content_type: MimeMagic.by_magic(file_handler)
          }
        end

        if fresh_file
          if file.save
            Occams.logger.info("[CMS SEEDS] Imported File \t #{file_path}")
          else
            Occams.logger.warn("[CMS SEEDS] Failed to import File \n#{file.errors.inspect}")
          end
        end

        seed_ids << file.id
      end

      # cleaning up
      site.files.where('id NOT IN (?)', seed_ids).destroy_all
    end
  end
end
