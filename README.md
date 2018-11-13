# Rails Structure Sample

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
Decorators adds an object-oriented layer of presentation logic to your Rails application

```ruby
class ListingDecorator < Draper::Decorator

  delegate_all
  include ActionView::Helpers::NumberHelper

  def short_title
    object.title
  end

  def picture_url
    pictures = object.pictures
    pictures.first.url.medium_with_watermark.url if pictures.present?
  end

end

```

[Examples](app/decorators)

[Documentation](https://github.com/drapergem/draper)

## Helpers
Helpers in Rails are used to extract complex logic out of the view so that you can organize your code better.

```ruby
module LeadsHelper
  
  def difference_mark(num)
    return "+ #{num}" if num.positive?
  end
  
  def chart_periods
    [['7 days', 7], ['14 days', 14], ['1 month', 30], ['6 month', 180]]
  end
  
  def statistic_period
    [['7 days', 7.days.ago], ['14 days', 14.days.ago], ['1 month', 30.days.ago], ['6 month', 180.days.ago]]
  end

end

```

[Examples](app/helpers)

[Documentation](https://api.rubyonrails.org/classes/ActionController/Helpers.html)
## Models
Active Record is the M in MVC - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database.

```ruby
# == Schema Information
#
# Table name: colors
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Color < ApplicationRecord

  # == Constants ============================================================

  # == Attributes ===========================================================
  attribute :name

  # == Extensions ===========================================================
  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors

  # == Relationships ========================================================
  has_many :vehicle_listings, dependent: :nullify

  # == Validations ==========================================================
  validates(*Color.globalize_attribute_names, presence: true)

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

end

```

[Examples](app/models)

[Documentation](https://guides.rubyonrails.org/active_model_basics.html)

## Services
Service Object can be a class or module in Ruby that performs an action. It can help take out logic from other areas of the MVC files.

```ruby
module Page

  attr_reader :partner, :currency, :params

  def initialize(options = {})
    @partner  = options[:partner]
    @params   = options[:params]   || {}
    @currency = options[:currency] || 'USD'
  end

  def listings
    ::Filter::Listings.call(filtering_params: filtering_params,
                            ads: partner.vehicle_listings.validated,
                            page: params[:page])
  end

  def price_range
    ::Calculate::PriceRange.call(VehicleListing.prices, currency)
  end

  def filtering_params
    ::Filter::ParamsProcessor.call(params: params, query_parameter: :listing, currency: currency)
  end

    end
```
[Examples](app/services)

## Presenters
Presenters give you an object oriented way to approach view helpers

```ruby

```
## Workers
At codica we use sidekiq as a full-featured background processing framework for Ruby. It aims to be simple to integrate with any modern Rails application and much higher performance than other existing solutions.

```ruby
class PartnerAlertWorker

  include Sidekiq::Worker
  sidekiq_options queue: ENV['CARRIERWAVE_BACKGROUNDER_QUEUE'].to_sym

  def perform(id)
    @partner = Partner.find(id)
    PartnerMailer.alert(@partner).deliver_now
  end

end


```
[Examples](app/workers)

[Documentation](https://github.com/mperham/sidekiq/wiki)
## Node Modules


## Spec
Spec folder include the test suites, the application logic tests.

```ruby
require 'rails_helper'

RSpec.feature 'Static page', type: :feature do
  let(:ad) { create :vehicle_listing }

  scenario 'unsuccess payment' do
    visit payment_info_error_path(ad: ad.id)
    expect(page).to have_content I18n.t('unsuccess_payment_header')
  end

  scenario 'success payment' do
    visit payment_info_success_path(promotion: 'on_homepage', price: '30')
    expect(page).to have_content I18n.t('success_payment_header')
  end

end

```

[Examples](https://github.com/codica2/rspec-samples)

[Documentation](https://relishapp.com/rspec/)

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
