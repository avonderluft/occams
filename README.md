# ocCaM'S

Prefer Simplicity

## Raison d'etre

ocCaM'S is a revival of [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa), with all due thanks and acknowledgements to [Oleg Khabarov](https://github.com/GBH), et al. 'Comfy' was the simplest and cleanest Rails-based CMS that I had used. Its last commit was in 2020, and I simply did not want to see it die on the vine as [RadiantCMS](https://github.com/radiant/radiant) did some years ago.

```
             ____      __  __ _ ____
  ___   ___ / ___|__ _|  \/  ( ) ___|
 / _ \ / __| |   / _` | |\/| |/\___ \
| (_) | (__| |__| (_| | |  | |  ___) |
 \___/ \___|\____\__,_|_|  |_| |____/

``` 

## The name

ocCaM'S, pronounced "AH-kums" is a nod to [Occam's Razor](https://en.wikipedia.org/wiki/Occam%27s_razor) - for this Rails-based Content Management System endeavors to follow the principle that the preferred solution is that which is simplest and built with the smallest possible set of components.

## Features

* Simple drop-in integration with Rails 6.0+ apps with minimal configuration
* CMS stays away from the rest of your application

Referring to the [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) documentation, substituting 'Occams' for 'ComfortableMexicanSofa' where appropriate.

* Powerful page templating capability using [Content Tags](https://github.com/comfy/comfortable-mexican-sofa/wiki/Docs:-Content-Tags)
* [Multiple Sites](https://github.com/ocms/comfortable-mexican-sofa/wiki/Docs:-Sites) from a single installation
* Multi-Language Support (i18n) (ca, cs, da, de, en, es, fi, fr, gr, hr, it, ja, nb, nl, pl, pt-BR, ru, sv, tr, uk, zh-CN, zh-TW) and page localization.
* [CMS Seeds](https://github.com/comfy/comfortable-mexican-sofa/wiki/Docs:-CMS-Seeds) for initial content population
* [Revision History](https://github.com/comfy/comfortable-mexican-sofa/wiki/Docs:-Revisions) to revert changes
* [Extendable Admin Area](https://github.com/comfy/comfortable-mexican-sofa/wiki/HowTo:-Reusing-Admin-Area) built with [Bootstrap 4](http://getbootstrap.com) (responsive design). Using [CodeMirror](http://codemirror.net) for HTML and Markdown highlighing and [Redactor](http://imperavi.com/redactor) as the WYSIWYG editor.

## Dependencies

* File attachments are handled by [ActiveStorage](https://github.com/rails/rails/tree/master/activestorage). Make sure that you can run appropriate migrations by running: `rails active_storage:install` and then `rake db:migrate`
* Image resizing is done with with [ImageMagick](http://www.imagemagick.org/script/download.php), so make sure it's installed.
* Pagination is handled by [kaminari](https://github.com/amatsuda/kaminari) or [will_paginate](https://github.com/mislav/will_paginate). Please add one of those to your Gemfile.

## Compatibility

- Install and basic functionality validated on Ruby 3.2.2. with Rails 6.1.7.4 and 7.0.6
- >= Rails 7 is recommended, since performance is noticably better

## Installation

Add gem definition to your Gemfile:

```ruby
gem "occams"
```

* From the Rails project's root run:  
  `bundle install`
* Then add the CMS:  
  `rails generate occams:cms`
* If you want to store files in your CMS with Active Storage:  
  `rails active_storage:install`
* Set up the database:  
  `rails db:migrate`
    
Now take a look inside your `config/routes.rb` file. You'll see where routes attach for the admin area and content serving. Make sure that content serving route appears as a very last item or it will make all other routes to be inaccessible.

```ruby
occams_route :cms_admin, path: "/admin"
occams_route :cms, path: "/"
```

## Quick Start Guide

After finishing installation you should be able to navigate to http://localhost:3000/admin

Default username and password is 'user' and 'pass'. You probably want to change it right away. Admin credentials (among other things) can be found and changed in the cms initializer: [/config/initializers/occams.rb](https://github.com/avonderluft/occams/blob/main/config/initializers/occams.rb)

Before creating pages and populating them with content we need to create a Site. Site defines a hostname, content path and its language.

After creating a Site, you need to make a Layout. Layout is the template of your pages; it defines some reusable content (like header and footer, for example) and places where the content goes. A very simple layout can look like this:

```html
<html>
  <body>
    <h1>{{ cms:text title }}</h1>
    {{ cms:wysiwyg content }}
  </body>
</html>
```

Once you have a layout, you may start creating pages and populating content. It's that easy.

## Documentation

Refer to the [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) documentation, substituting 'Occams' for 'Comfy' where appropriate.

For more information on how to use this CMS please refer to the [Wiki](https://github.com/comfy/comfortable-mexican-sofa/wiki). Section that might be of interest is the entry
on [Content Tags](https://github.com/comfy/comfortable-mexican-sofa/wiki/Docs:-Content-Tags).

[Ocms Demo App](https://github.com/comfy/comfy-demo) also can be used as an
example of a default Rails app with CMS installed.

#### Contributing

The Occams repository can run like any Rails application in development. It's as easy to work on as any other Rails app.
For more detail see [CONTRIBUTING](CONTRIBUTING.md)

#### Acknowledgements

- Obviously to Oleg Khabarov, the creator of [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa). This is his work, with just a few updates and additions.
- Thanks to [Roman Almeida](https://github.com/nasmorn) for contributing OEM License for [Redactor Text Editor](http://imperavi.com/redactor)

---
- [ComfortableMexicanSofa](https://github.com/comfy/comfortable-mexican-sofa) Copyright 2010-2019 Oleg Khabarov. Released under the [MIT license](LICENSE)
- [Occams](https://github.com/avonderluft/occams) follows suit, being also released under the [MIT license](LICENSE)
