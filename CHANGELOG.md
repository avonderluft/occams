# Changelog

## v1.0.7.1 - 9/d/2023

- address deprecations for file type 'image/jpg'

## v1.0.7 - 9/12/2023

- update coveralls Coverage reporting
- add minitest-reporters for test output
- adjust tests to accomodate varying macos and linux outputs
- refine test for 'children' tag
- linting and 1 typo
- add Build Status and Coveralls Coverage Status to README

## v1.0.6.1 - 9/5/2023

- Fixed siblings and children nav tags which as written had problems creating child pages in the admin panel

## v1.0.6 - 9/5/2023

- Fixed [cms:siblings Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#siblings) to handle edge case when page(s) are excluded by the `exclude` parameter
- Added [cms:children Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#children) to render unordered list of links for children of current page

## v1.0.5 - 8/31/2023

- All tests now green on Rails 6.1 and 7.0, each tested with rubies 2.7.8, 3.1.4 and 3.2.2.
- Tests added for new tags
- TODO: set up CI pipeline

## v1.0.4 - 8/26/2023

- Added [cms:breadcrumbs Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#breadcrumbs)
- Added [cms:siblings Nav tag](https://github.com/avonderluft/occams/wiki/Content-Tags#siblings)
- Updated [wiki documentation](https://github.com/avonderluft/occams/wiki)

## v1.0.3 - 8/15/2023

- Added a [cms:audio tag](https://github.com/avonderluft/occams/wiki/Content-Tags#audio) for an embedded audio player
- Some formatting of admin menu footer

## v1.0.2 - 8/14/2023

- Fixed image rendering which rubocop broke in v1.0.1
- Show unpublished pages in Rails development mode
- Show Rails ENV at foot of Admin menu, along with versions of Occams, Rails and Ruby
- Updated documentation at [Occams Wiki](https://github.com/avonderluft/occams/wiki) 
- Comprehensive rubocop linting

## v1.0.1 - 8/7/2023

- Fixed image thumbnail hover for Rails 7
- Added display of Rails and Ruby versions along with Occams version at foot of Admin menu
- Refined gemspec dependencies
- Tweaked with a bunch of rubocop linting

## v1.0.0 - 8/5/2023

- Copied the original [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa)
- Added the changes from [Restarone's fork](https://github.com/restarone/comfortable-mexican-sofa) (23 commits)
- Added the ability to write snippets in Markdown