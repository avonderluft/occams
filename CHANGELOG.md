# Changelog

## v.1.1.0 13 January 2024

- Rails 7.1 compatibility, all tests passing
- corrected bug in siblings tag to not display links to unpublished pages
- updated README

## v1.0.8 - 29 December 2023

- Updated configs, et al. in pursuit of Rails 7.1 compatibility
- Added explicit coder for serialize commands
- Added ActiveRecord Adapter (database) info to admin footer
- Added commented defaults for MySQL and Postgres to database.yml
- Updated documentation
- Refactored lib files for better test coverage awareness

## v1.0.7.3 - 7 October 2023

- Fixed edge case with siblings tag when current page is excluded
- Git ignore all sqlite* files for testing
- Small testing refinements
- Prep for Rails 7.1 compatibility

## v1.0.7.2 - 27 September 2023

- Pulled will_paginate option out in favor of Kaminari
- Switched CI from Buildkite to [Github actions](https://github.com/avonderluft/occams/actions/workflows/rubyonrails.yml)
- Improved test coverage to 99+
- Removed backward compatibility to Rails prior to 6.x

## v1.0.7.1 - 22 September 2023

- Addressed deprecations for file type 'image/jpg'
- Added github workflow for tests, lints and audits
- Fixed some flagged security warnings
- Bumped rubocop version to latest
- Updated some testing parameters

## v1.0.7 - 12 September 2023

- Updated coveralls Coverage reporting
- Added minitest-reporters for test output
- Adjusted tests to accomodate varying macos and linux outputs
- Refined test for 'children' tag
- Lints and 1 typo
- Added Build Status and Coveralls Coverage Status to README

## v1.0.6.1 - 5 September 2023

- Fixed siblings and children nav tags which as written had problems creating child pages in the admin panel

## v1.0.6 - 5 September 2023

- Fixed [cms:siblings Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#siblings) to handle edge case when page(s) are excluded by the `exclude` parameter
- Added [cms:children Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#children) to render unordered list of links for children of current page

## v1.0.5 - 31 August 2023

- All tests now green on Rails 6.1 and 7.0, each tested with rubies 2.7.8, 3.1.4 and 3.2.2.
- Tests added for new tags
- TODO: set up CI pipeline

## v1.0.4 - 26 August 2023

- Added [cms:breadcrumbs Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#breadcrumbs)
- Added [cms:siblings Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#siblings)
- Updated [wiki documentation](https://github.com/avonderluft/occams/wiki)

## v1.0.3 - 15 August 2023

- Added a [cms:audio tag](https://github.com/avonderluft/occams/wiki/Content-Tags#audio) for an embedded audio player
- Some formatting of admin menu footer

## v1.0.2 - 14 August 2023

- Fixed image rendering which rubocop broke in v1.0.1
- Show unpublished pages in Rails development mode
- Show Rails ENV at foot of Admin menu, along with versions of Occams, Rails and Ruby
- Updated documentation at [Occams Wiki](https://github.com/avonderluft/occams/wiki) 
- Comprehensive rubocop linting

## v1.0.1 - 7 August 2023

- Fixed image thumbnail hover for Rails 7
- Added display of Rails and Ruby versions along with Occams version at foot of Admin menu
- Refined gemspec dependencies
- Tweaked with a bunch of rubocop linting

## v1.0.0 - 5 August 2023

- Copied the original [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa)
- Added the changes from [Restarone's fork](https://github.com/restarone/comfortable-mexican-sofa) (23 commits)
- Added the ability to write snippets in Markdown