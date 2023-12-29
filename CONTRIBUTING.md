# Contributing

Contribute your code to Occams in 5 easy steps:

### 1. Fork it

Fork the project. Optionally, create a branch you want to work on.

### 2. Get it running locally

- Install gem dependencies with `bundle install`
- There's nothing to configure, by default database is SQLite so it will be
  created for you. Just run `bundle exec rake db:migrate`
- Make sure that existing tests are passing by running `bundle exec rake test`
- There are system tests that can be run with `bundle exec rake test:system`.
  You need to have `chromedriver` installed for that.
- You should be able to start the app via `bin/rails s` and navigate to http://localhost:3000/admin

### 3. Hack away

- Create a few small pull requests instead of a humoungous one. I can merge small stuff faster.
- When adding new code just make sure it follows the same slyle as the existing code.
- Avoid adding 3rd party dependencies if you can.
- Tests please, but nothing complicated. UnitTest / Fixtures all the way. Make sure all tests pass.
- Run `bundle exec rubocop` and fix any issues raised.

### 4. Create a pull request

- If you never done it before read this: https://help.github.com/articles/using-pull-requests
- When PR is submitted check if [Github Actions](https://github.com/avonderluft/occams/actions) ran all tests successfully and Rubocop didn't raise any issues

### 5. Done!

If everything looks good, we will review your changes to be merged into the main branch, and publish a new version of the gem.
