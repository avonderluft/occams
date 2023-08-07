# frozen_string_literal: true

require_relative "../../test_helper"

class SeedsFilesTest < ActiveSupport::TestCase
  setup do
    @site = occams_cms_sites(:default)
  end

  def test_creation
    Occams::Cms::File.delete_all

    assert_difference -> { Occams::Cms::File.count } do
      Occams::Seeds::File::Importer.new("sample-site", "default-site").import!
    end

    assert file = Occams::Cms::File.last

    assert_equal "Seed File",   file.label
    assert_equal "default.jpg", file.attachment.filename.to_s
    assert_equal "image/jpeg",  file.attachment.content_type
    assert_equal "Seed File Description", file.description

    assert_equal 2, file.categories.count
    assert_equal %w[category_a category_b], file.categories.map(&:label)
  end

  def test_update
    file = occams_cms_files(:default)
    file.update_column(:updated_at, 10.years.ago)
    assert_equal "default.jpg",         file.attachment.filename.to_s
    assert_equal "default file",        file.label
    assert_equal "default description", file.description

    assert_no_difference -> { Occams::Cms::File.count } do
      Occams::Seeds::File::Importer.new("sample-site", "default-site").import!
      file.reload
      assert_equal "default.jpg",           file.attachment.filename.to_s
      assert_equal "Seed File",             file.label
      assert_equal "Seed File Description", file.description
    end
  end

  def test_update_ignore
    file = occams_cms_files(:default)
    file_path = File.join(Occams.config.seeds_path, "sample-site", "files", "default.jpg")
    attr_path = File.join(Occams.config.seeds_path, "sample-site", "files", "_default.jpg.yml")

    assert file.updated_at >= File.mtime(file_path)
    assert file.updated_at >= File.mtime(attr_path)

    Occams::Seeds::File::Importer.new("sample-site", "default-site").import!
    file.reload
    assert_equal "default.jpg",         file.attachment.filename.to_s
    assert_equal "default file",        file.label
    assert_equal "default description", file.description
  end

  def test_delete
    old_file = occams_cms_files(:default)
    active_storage_blobs(:default).update_column(:filename, "old")

    assert_no_difference -> { Occams::Cms::File.count } do
      Occams::Seeds::File::Importer.new("sample-site", "default-site").import!
      assert file = Occams::Cms::File.last
      assert_equal "default.jpg",           file.attachment.filename.to_s
      assert_equal "Seed File",             file.label
      assert_equal "Seed File Description", file.description

      assert Occams::Cms::File.where(id: old_file.id).blank?
    end
  end

  def test_export
    host_path = File.join(Occams.config.seeds_path, "test-site")
    attr_path = File.join(host_path, "files/_default.jpg.yml")
    file_path = File.join(host_path, "files/default.jpg")

    # We don't have saved file, so lets fake that
    ActiveStorage::Blob.any_instance.stubs(:download).returns(
      File.read(File.join(Rails.root, "db/cms_seeds/sample-site/files/default.jpg"))
    )

    Occams::Seeds::File::Exporter.new("default-site", "test-site").export!

    assert File.exist?(attr_path)
    assert File.exist?(file_path)
    assert_equal ({
      "label" => "default file",
      "description" => "default description",
      "categories" => ["Default"]
    }), YAML.load_file(attr_path)
  ensure
    FileUtils.rm_rf(host_path)
  end
end
