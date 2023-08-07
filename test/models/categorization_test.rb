# frozen_string_literal: true

require_relative "../test_helper"

class CmsCategorizationTest < ActiveSupport::TestCase
  setup do
    @category = occams_cms_categories(:default)
  end

  def test_fixtures_validity
    Occams::Cms::Categorization.all.each do |categorization|
      assert categorization.valid?, categorization.errors.full_messages.to_s
    end
  end

  def test_validation
    category = Occams::Cms::Categorization.new
    assert category.invalid?
    assert_has_errors_on category, :category, :categorized
  end

  def test_creation
    assert_difference "Occams::Cms::Categorization.count" do
      @category.categorizations.create!(
        categorized: occams_cms_pages(:default)
      )
    end
  end

  def test_categorized_relationship
    file = occams_cms_files(:default)
    assert file.respond_to?(:category_ids)
    assert_equal 1, file.categories.count
    assert_equal @category, file.categories.first

    assert occams_cms_pages(:default).respond_to?(:category_ids)
    assert_equal 0, occams_cms_pages(:default).categories.count
  end

  def test_categorized_destruction
    file_count            = -> { Occams::Cms::File.count }
    categorization_count  = -> { Occams::Cms::Categorization.count }

    assert_difference([file_count, categorization_count], -1) do
      occams_cms_files(:default).destroy
    end
  end

  def test_categorized_syncing
    # or we're not going to be able to link
    @category.update_column(:categorized_type, "Occams::Cms::Page")

    page = occams_cms_pages(:default)
    assert_equal 0, page.categories.count

    page.update(category_ids: [@category.id, 9999])

    page.reload
    assert_equal 1, page.categories.count

    page.update(category_ids: [])
    page.reload
    assert_equal 0, page.categories.count
  end

  def test_scope_for_category
    category = @category
    assert_equal 1, Occams::Cms::File.for_category(category.label).count
    assert_equal 0, Occams::Cms::File.for_category("invalid").count
    assert_equal 1, Occams::Cms::File.for_category(category.label, "invalid").count
    assert_equal 1, Occams::Cms::File.for_category(nil).count

    new_category = occams_cms_sites(:default).categories.create!(
      label: "Test Category",
      categorized_type: "Occams::Cms::File"
    )
    new_category.categorizations.create!(categorized: occams_cms_pages(:default))
    assert_equal 1, Occams::Cms::File.for_category(category.label, new_category.label).to_a.size
    assert_equal 1,
                 Occams::Cms::File.for_category(category.label,
                                                new_category.label).distinct.count("occams_cms_files.id")
  end
end
