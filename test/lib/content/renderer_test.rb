# frozen_string_literal: true

require_relative '../../test_helper'

class ContentRendererTest < ActiveSupport::TestCase
  class TestTag < Occams::Content::Tag
    def content
      'test tag content'
    end
  end

  class TestNestedTag < Occams::Content::Tag
    def content
      'test {{cms:test}} content'
    end
  end

  class TestBlockTag < Occams::Content::Block
    # ...
  end

  DEFAULT_REGISTERED_TAGS = {
    'wysiwyg' => Occams::Content::Tags::Wysiwyg,
    'text' => Occams::Content::Tags::Text,
    'textarea' => Occams::Content::Tags::Textarea,
    'markdown' => Occams::Content::Tags::Markdown,
    'datetime' => Occams::Content::Tags::Datetime,
    'date' => Occams::Content::Tags::Date,
    'number' => Occams::Content::Tags::Number,
    'checkbox' => Occams::Content::Tags::Checkbox,
    'file' => Occams::Content::Tags::File,
    'files' => Occams::Content::Tags::Files,
    'snippet' => Occams::Content::Tags::Snippet,
    'asset' => Occams::Content::Tags::Asset,
    'file_link' => Occams::Content::Tags::FileLink,
    'page_file_link' => Occams::Content::Tags::PageFileLink,
    'helper' => Occams::Content::Tags::Helper,
    'partial' => Occams::Content::Tags::Partial,
    'template' => Occams::Content::Tags::Template,
    'audio' => Occams::Content::Tags::Audio,
    'breadcrumbs' => Occams::Content::Tags::Breadcrumbs,
    'children' => Occams::Content::Tags::Children,
    'siblings' => Occams::Content::Tags::Siblings
  }.freeze

  setup do
    @page     = occams_cms_pages(:default)
    @template = Occams::Content::Renderer.new(@page)

    Occams::Content::Renderer.register_tag(:test, TestTag)
    Occams::Content::Renderer.register_tag(:test_nested, TestNestedTag)
    Occams::Content::Renderer.register_tag(:test_block, TestBlockTag)
  end

  teardown do
    Occams::Content::Renderer.tags.delete('test')
    Occams::Content::Renderer.tags.delete('test_nested')
    Occams::Content::Renderer.tags.delete('test_block')
  end

  # Test helper so we don't have to do this each time
  def render_string(string, template = @template)
    tokens = template.tokenize(string)
    nodes  = template.nodes(tokens)
    template.render(nodes)
  end

  # -- Tests -------------------------------------------------------------------

  def test_tags
    assert_equal DEFAULT_REGISTERED_TAGS.merge(
      'test' => ContentRendererTest::TestTag,
      'test_nested' => ContentRendererTest::TestNestedTag,
      'test_block' => ContentRendererTest::TestBlockTag
    ), Occams::Content::Renderer.tags
  end

  def test_register_tags
    Occams::Content::Renderer.register_tag(:other, TestTag)
    assert_equal DEFAULT_REGISTERED_TAGS.merge(
      'test' => ContentRendererTest::TestTag,
      'test_nested' => ContentRendererTest::TestNestedTag,
      'test_block' => ContentRendererTest::TestBlockTag,
      'other' => ContentRendererTest::TestTag
    ), Occams::Content::Renderer.tags
  ensure
    Occams::Content::Renderer.tags.delete('other')
  end

  def test_tokenize
    assert_equal ['test text'], @template.tokenize('test text')
  end

  def test_tokenize_with_tag
    assert_equal ['test ', { tag_class: 'tag', tag_params: '', source: '{{cms:tag}}' }, ' text'],
                 @template.tokenize('test {{cms:tag}} text')
  end

  def test_tokenize_with_tag_and_params
    expected = [
      'test ',
      { tag_class: 'tag', tag_params: 'name, key:val', source: '{{cms:tag name, key:val}}' },
      ' text'
    ]
    assert_equal expected, @template.tokenize('test {{cms:tag name, key:val}} text')
  end

  def test_tokenize_with_invalid_tag
    assert_equal ['test {{abc:tag}} text'],
                 @template.tokenize('test {{abc:tag}} text')
  end

  def test_tokenize_with_newlines
    expected = [
      { tag_class: 'test', tag_params: '', source: '{{cms:test}}' },
      "\n",
      { tag_class: 'test', tag_params: '', source: '{{cms:test}}' }
    ]
    assert_equal expected, @template.tokenize("{{cms:test}}\n{{cms:test}}")
  end

  def test_nodes
    tokens = @template.tokenize('test')
    nodes = @template.nodes(tokens)
    assert_equal ['test'], nodes
  end

  def test_nodes_with_tags
    tokens = @template.tokenize('test {{cms:test}} content {{cms:test}}')
    nodes = @template.nodes(tokens)
    assert_equal 4, nodes.count
    assert_equal 'test ', nodes[0]
    assert nodes[1].is_a?(ContentRendererTest::TestTag)
    assert_equal ' content ', nodes[2]
    assert nodes[3].is_a?(ContentRendererTest::TestTag)
  end

  def test_nodes_with_tag_with_params
    tokens = @template.tokenize('{{cms:test param, key: value}}')
    nodes = @template.nodes(tokens)
    assert_equal 1, nodes.count
    assert nodes[0].is_a?(ContentRendererTest::TestTag)
    tag = nodes[0]
    assert_equal @page, tag.context
    assert_equal ['param', { 'key' => 'value' }], tag.params
    assert_equal '{{cms:test param, key: value}}', tag.source
  end

  def test_nodes_with_block_tag
    string = 'a {{cms:test_block}} b {{cms:end}} c'
    tokens = @template.tokenize(string)
    nodes = @template.nodes(tokens)
    assert_equal 3, nodes.count

    assert_equal 'a ', nodes[0]
    assert_equal ' c', nodes[2]

    block = nodes[1]
    assert block.is_a?(ContentRendererTest::TestBlockTag)
    assert_equal [' b '], block.nodes
  end

  def test_nodes_with_block_tag_and_tag
    string = 'a {{cms:test_block}} b {{cms:test}} c {{cms:end}} d'
    tokens = @template.tokenize(string)
    nodes = @template.nodes(tokens)
    assert_equal 3, nodes.count
    assert_equal 'a ', nodes[0]
    assert_equal ' d', nodes[2]

    block = nodes[1]
    assert block.is_a?(ContentRendererTest::TestBlockTag)
    assert_equal 3, block.nodes.count
    assert_equal ' b ', block.nodes[0]
    assert_equal ' c ', block.nodes[2]

    tag = block.nodes[1]
    assert tag.is_a?(ContentRendererTest::TestTag)
    assert_equal ['test tag content'], tag.nodes
  end

  def test_nodes_with_nested_block_tag
    string = 'a {{cms:test_block}} b {{cms:test_block}} c {{cms:end}} d {{cms:end}} e'
    tokens = @template.tokenize(string)
    nodes = @template.nodes(tokens)
    assert_equal 3, nodes.count
    assert_equal 'a ', nodes[0]
    assert_equal ' e', nodes[2]

    block = nodes[1]
    assert block.is_a?(ContentRendererTest::TestBlockTag)
    assert_equal 3, block.nodes.count
    assert_equal ' b ', block.nodes[0]
    assert_equal ' d ', block.nodes[2]

    block = block.nodes[1]
    assert_equal [' c '], block.nodes
  end

  def test_nodes_with_unclosed_block_tag
    string = 'a {{cms:test_block}} b'
    tokens = @template.tokenize(string)
    message = 'unclosed block detected'
    assert_raises Occams::Content::Renderer::SyntaxError, message do
      @template.nodes(tokens)
    end
  end

  def test_nodes_with_closed_tag
    string = 'a {{cms:end}} b'
    tokens = @template.tokenize(string)
    message = 'closing unopened block'
    assert_raises Occams::Content::Renderer::SyntaxError, message do
      @template.nodes(tokens)
    end
  end

  def test_nodes_with_invalid_tag
    string = 'a {{cms:invalid}} b'
    tokens = @template.tokenize(string)
    message = 'Unrecognized tag: {{cms:invalid}}'
    assert_raises Occams::Content::Renderer::SyntaxError, message do
      @template.nodes(tokens)
    end
  end

  def test_sanitize_erb
    out = @template.sanitize_erb('<% test %>', false)
    assert_equal '&lt;% test %&gt;', out

    out = @template.sanitize_erb('<% test %>', true)
    assert_equal '<% test %>', out
  end

  def test_render
    out = render_string('test')
    assert_equal 'test', out
  end

  def test_render_with_tag
    out = render_string('a {{cms:text content}} z')
    assert_equal 'a content z', out
  end

  def test_render_with_erb
    out = render_string('<%= 1 + 1 %>')
    assert_equal '&lt;%= 1 + 1 %&gt;', out
  end

  def test_render_with_erb_allowed
    Occams.config.allow_erb = true
    out = render_string('<%= 1 + 1 %>')
    assert_equal '<%= 1 + 1 %>', out
  end

  def test_render_with_erb_allowed_via_tag
    out = render_string('{{cms:partial path}}')
    assert_equal '<%= render partial: "path", locals: {} %>', out
  end

  def test_render_with_nested_tag
    string = 'a {{cms:text content}} b'
    occams_cms_fragments(:default).update_column(:content, 'c {{cms:snippet default}} d')
    occams_cms_snippets(:default).update_column(:content, 'e {{cms:helper test}} f')
    out = render_string(string)
    assert_equal 'a c e <%= test() %> f d b', out
  end

  def test_render_stack_overflow
    # making self-referencing content loop here
    occams_cms_snippets(:default).update_column(:content, 'a {{cms:snippet default}} b')
    message = 'Deep tag nesting or recursive nesting detected'
    assert_raises Occams::Content::Renderer::Error, message do
      render_string('{{cms:snippet default}}')
    end
  end
end
