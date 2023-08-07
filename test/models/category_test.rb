# frozen_string_literal: true

require_relative "../test_helper"

class CmsCategoryTest < ActiveSupport::TestCase
  def test_fixtures_validity
    Occams::Cms::Category.all.each do |category|
      assert category.valid?, category.errors.full_messages.to_s
    end
  end

  def test_validation
    category = Occams::Cms::Category.new
    assert category.invalid?
    assert_has_errors_on category, :site, :label, :categorized_type
  end

  def test_creation
    assert_difference "Occams::Cms::Category.count" do
      occams_cms_sites(:default).categories.create(
        label: "Test Category",
        categorized_type: "Occams::Cms::Snippet"
      )
    end
  end

  def test_destruction
    category = occams_cms_categories(:default)
    assert_equal 1, category.categorizations.count

    category_count = -> { Occams::Cms::Category.count }
    categorization_count = -> { Occams::Cms::Categorization.count }
    assert_difference([category_count, categorization_count], -1) do
      category.destroy
    end
  end

  def test_scope_of_type
    assert_equal 1, Occams::Cms::Category.of_type("Occams::Cms::File").count
    assert_equal 0, Occams::Cms::Category.of_type("Invalid").count
  end
end
