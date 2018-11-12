#Rails Structure Sample

![Rails Structure](https://images.onlinelabels.com/images/clip-art/GDJ/Tree%20And%20Leaves%20Silhouette-254171.png)

## Description



## File structure

``` 
project_name
    ├── app
    |   ├── assets  => images, fonts, stylesheets, js
    |   ├── controllers => app controllers
    |   ├── decorators => app decorators
    |   ├── helpers => app helpers
    |   ├── javascript => Contains js code if you are using webpacker gem
    |   ├── mailers => app mailers
    |   ├── models => app models
    |   ├── services 
    |   ├── uploaders 
    |   ├── presenters 
    |   ├── views => Contains app views.
    |   └── workers => workers for running processes in the background
    ├── bin =>  contains script that starts, update, deploy or run your application.
    ├── config  => configure your application's routes, database, and more
    ├── db => contains your current database schema and migrations
    ├── lib => extended modules for your application
    ├── log => app log files
    ├── node_modules 
    ├── public => The only folder seen by the world as-is. Contains static files and compiled assets.
    ├── scripts
    ├── spec => Unit tests, features, and other test apparatus.
    ├── tmp => Temporary files (like cache and pid files).
    └── vendor  => third-party code
```
## Controllers
Action Controller is the C in MVC. After routing has determined which controller to use for a request, your controller is responsible for making sense of the request and producing the appropriate output

```ruby
class TagsController < ApplicationController

  def show
    add_breadcrumb I18n.t('shared.footer.home'), :root_path
    add_breadcrumb I18n.t('shared.header.blog'), :blog_path
    add_breadcrumb I18n.t('posts.index.tags'), :tag_path

    @page = Page::Blog::Tag.new(params[:id], params[:page])
  end

end
```
[Examples](app/controllers)

[Documentation](https://edgeguides.rubyonrails.org/action_controller_overview.html)
## Decorators

## Helpers

## Models

## Services

## Presenters

## Workers

## Node Modules

## License

The MIT License (MIT)

[![Codica logo](https://www.codica.com/assets/images/logo/logo.svg)](https://www.codica.com/)

Copyright (c) 2018 Codica

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
