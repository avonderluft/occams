# frozen_string_literal: true

require_relative 'lib/occams/version'

Gem::Specification.new do |spec|
  spec.name          = 'occams'
  spec.version       = Occams::VERSION
  spec.authors       = ['Andrew vonderLuft']
  spec.email         = ['wonder@hey.com']
  spec.homepage      = 'http://github.com/avonderluft/occams'
  spec.summary       = 'Rails 6.1-7.1+ CMS Engine'
  spec.description   = 'Occams is a powerful Rails 6.1-7.1+ CMS Engine'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|doc)/})
  end

  spec.required_ruby_version = '>= 3.0.0'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'active_link_to',       '~> 1.0',   '>= 1.0.5'
  spec.add_dependency 'comfy_bootstrap_form', '~> 4.0',   '>= 4.0.0'
  spec.add_dependency 'haml-rails',           '~> 2.1',   '>= 2.1.0'
  spec.add_dependency 'image_processing',     '~> 1.2',   '>= 1.12.2'
  spec.add_dependency 'jquery-rails',         '~> 4.6',   '>= 4.6.0'
  spec.add_dependency 'kaminari',             '~> 1.2',   '>= 1.2.2'
  spec.add_dependency 'kramdown',             '~> 2.4',   '>= 2.4.0'
  spec.add_dependency 'mimemagic',            '~> 0.4',   '>= 0.4.3'
  spec.add_dependency 'mini_magick',          '~> 4.12',  '>= 4.12.0'
  spec.add_dependency 'rails',                '>= 6.1.0'
  spec.add_dependency 'rails-i18n',           '>= 6.0.0'
  spec.add_dependency 'sassc-rails',          '~> 2.1',   '>= 2.1.2'
  spec.add_dependency 'sprockets-rails',      '~> 3.4',   '>= 3.4.2'
end
