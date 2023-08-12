# frozen_string_literal: true

require_relative '../test_helper'

class SeedsTest < ActiveSupport::TestCase
  def test_import_all
    Occams::Cms::Page.destroy_all
    Occams::Cms::Layout.destroy_all
    Occams::Cms::Snippet.destroy_all

    assert_difference(-> { Occams::Cms::Layout.count }, 2) do
      assert_difference(-> { Occams::Cms::Page.count }, 3) do
        assert_difference(-> { Occams::Cms::Snippet.count }, 1) do
          Occams::Seeds::Importer.new('sample-site', 'default-site').import!
        end
      end
    end
  end

  def test_import_all_with_no_site
    occams_cms_sites(:default).destroy

    assert_exception_raised ActiveRecord::RecordNotFound do
      Occams::Seeds::Importer.new('sample-site', 'default-site').import!
    end
  end

  def test_import_single_class
    Occams::Cms::Page.destroy_all
    Occams::Cms::Layout.destroy_all
    Occams::Cms::Snippet.destroy_all

    assert_difference(-> { Occams::Cms::Layout.count }, 2) do
      assert_difference(-> { Occams::Cms::Page.count }, 0) do
        assert_difference(-> { Occams::Cms::Snippet.count }, 0) do
          Occams::Seeds::Importer.new('sample-site', 'default-site').import!(['Layout'])
        end
      end
    end
  end

  def test_import_multiple_classes
    Occams::Cms::Page.destroy_all
    Occams::Cms::Layout.destroy_all
    Occams::Cms::Snippet.destroy_all

    assert_difference(-> { Occams::Cms::Layout.count }, 2) do
      assert_difference(-> { Occams::Cms::Page.count }, 0) do
        assert_difference(-> { Occams::Cms::Snippet.count }, 1) do
          Occams::Seeds::Importer.new('sample-site', 'default-site').import!(%w[Layout Snippet])
        end
      end
    end
  end

  def test_import_all_with_no_folder
    assert_exception_raised Occams::Seeds::Error do
      Occams::Seeds::Importer.new('invalid', 'default-site').import!
    end
  end

  def test_export_all
    ActiveStorage::Blob.any_instance.stubs(:download).returns(
      File.read(File.join(Rails.root, 'db/cms_seeds/sample-site/files/default.jpg'))
    )

    host_path = File.join(Occams.config.seeds_path, 'test-site')
    Occams::Seeds::Exporter.new('default-site', 'test-site').export!
  ensure
    FileUtils.rm_rf(host_path)
  end

  def test_export_all_with_no_site
    occams_cms_sites(:default).destroy

    assert_exception_raised ActiveRecord::RecordNotFound do
      Occams::Seeds::Exporter.new('sample-site', 'default-site').export!
    end
  end

  def test_export_single_class
    host_path = File.join(Occams.config.seeds_path, 'test-site')
    Occams::Seeds::Exporter.new('default-site', 'test-site').export!(['Layout'])
    assert(File.exist?(File.join(host_path, 'layouts')))
  ensure
    FileUtils.rm_rf(host_path)
  end

  def test_export_multiple_classes
    host_path = File.join(Occams.config.seeds_path, 'test-site')
    Occams::Seeds::Exporter.new('default-site', 'test-site').export!(%w[Layout Snippet])
    assert(%w[layouts snippets].all? { |klass| File.exist?(File.join(host_path, klass)) })
  ensure
    FileUtils.rm_rf(host_path)
  end
end
