# frozen_string_literal: true

require_relative "../../test_helper"

class ContentBlockTest < ActiveSupport::TestCase

  class TestBlockTag < Occams::Content::Block
    # ...
  end

  setup do
    Occams::Content::Renderer.register_tag(:test_block, TestBlockTag)
  end

  teardown do
    Occams::Content::Renderer.tags.delete("test_block")
  end

  # -- Tests -------------------------------------------------------------------

  def test_block_tag_nodes
    block = TestBlockTag.new(context: nil)
    assert_equal [], block.nodes
    block.nodes << "text"
    assert_equal ["text"], block.nodes
  end

end
