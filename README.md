<h1 align="center">Rails Structure Sample</h1>

## Description


## File structure

``` bash
project_name/
    ├── app
    |   ├── assets  => Holds the assets for your application including images, stylesheets, and javascript.
    |   ├── controllers => Contains app controllers
    |   ├── decorators => App decorators is a design pattern to remove view methods from models
    |   ├── helpers => Contains app helpers
    |   ├── javascript
    |   ├── mailers => Contains app mailers.
    |   ├── models => Contains app models
    |   ├── services => Contains app services. A service object implements the user’s interactions with the application. It contains business logic that describe the connections with your domain objects.
    |   ├── uploaders => A uploader is a class that is used by CarrierWave gem to model an uploaded file.
    |   ├── view_objects
    |   ├── views => Contains app views.
    |   └── workers => Workers are objects that allow you to run processes in the background
    ├── bin =>  Contains the rails script that starts your app and can contain other scripts you use to setup, update, deploy or run your application.
    ├── config  => Configure your application's routes, database, and more
    ├── db => Contains your current database schema, as well as the database migrations
    ├── lib => Extended modules for your application.
    ├── log => Application log files.
    ├── node_modules/
    ├── public => The only folder seen by the world as-is. Contains static files and compiled assets.
    ├── scripts
    ├── spec => Unit tests, fixtures, and other test apparatus.
    ├── tmp => Temporary files (like cache and pid files).
    └── vendor  => A place for all third-party code. In a typical Rails application this includes vendored gems.
```



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
