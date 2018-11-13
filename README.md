# Rails Structure Sample

![Rails Structure](https://www.iconsdb.com/icons/preview/icon-sets/web-2-ruby-red/tree-80-xxl.png)

## Description
Ruby on Rails is one of our favourite frameworks for web applications development. We love it because of agile and interesting development process, high performance and, of course, ruby programming language.
Below you can find an example of a project`s structure, and its main components
## File structure

``` 
project_name
    ├── app
    |   ├── assets  => images, fonts, stylesheets, js
    |   ├── controllers 
    |   ├── decorators 
    |   ├── helpers 
    |   ├── mailers
    |   ├── models 
    |   ├── performers
    |   ├── services 
    |   ├── uploaders 
    |   ├── presenters 
    |   ├── views 
    |   └── workers => workers for running processes in the background
    ├── bin     =>  contains script that starts, update, deploy or run your application.
    ├── config  => configure your application's routes, database, and more
    ├── db      => contains your current database schema and migrations
    ├── lib     => extended modules for your application
    ├── log     => app log files
    ├── public  => The only folder seen by the world as-is. Contains static files and compiled assets.
    ├── spec    => Unit tests, features, and other test apparatus.
    ├── tmp     => Temporary files (like cache and pid files).
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
module PartnersHelper

  def partner_activation(partner)
    partner.active? ? t('partners.extend_activation') : t('partners.activation')
  end
  

  def partner_info?(partner)
    partner.address.present? || partner.website.present?
  end

  def partner_edit_page_title(redirect_url)
    redirect_url.present? ? I18n.t('partners.upgrade_my_profile') : I18n.t('partners.edit_my_profile')
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

## Performers

The performer pattern creates seperation for the methods in your model that are view related. The performers are modules and are included into the corresponding model. 

```ruby
module InvestmentDataPerformer
  
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

  end
  
  def total_distribution
    investment.rental_properties? ? total_quarterly_distribution : total_distribution_dev
  end
  
  def profit_less_reserves_for_distribution
    return unless investment.profit_less_reserves_for_distribution

    investment.profit_less_reserves_for_distribution * holding / 100
  end

  def non_final_profit
    return nil unless investment.non_final_profit

    investment.non_final_profit * holding / 100
  end

  def final_distribution
    return unless investment.distribution.present?
    investment.distribution * holding / 100
  end

end

```

[Examples](app/performers)

[Documentation](https://github.com/jwipeout/performer-pattern)


## Services
Service Object can be a class or module in Ruby that performs an action. It can help take out logic from other areas of the MVC files.

```ruby
class CalculateCurrency < BaseService

  attr_reader :price, :currency, :rewert

  def initialize(options = {})
    @price = options[:price].to_i
    @currency = options[:currency]
    @rewert = options[:rewert] || nil
  end

  def call
    rate = get_rate(ExchangeRate.base_currency, Settings.currencies[currency])
    money = rate.present? ? get_price(rate) : price
    { currency: currency, price: money }
  end

  private

  def get_price(rate)
    rewert.present? ? (price / rate).floor : (rate * price).floor
  end

  def get_rate(from, to)
    Money.default_bank.get_rate(from, to)
  end

end

```
[Examples](app/services)

## Presenters
Presenters give you an object oriented way to approach view helpers.

```ruby
 class DividendYearDispatcher

   def initialize(dividend_year:, default_presenter: YearlyDistributionPresenter)
      @dividend_year = dividend_year
      @default_presenter = default_presenter
    end

    def results
      presenter.dividends_year
    end

    def presenter
      presenter_class(@dividend_year.distribution).new(@dividend_year)
    end

    def presenter_class(distribution)
      ('DividendYear::' + "#{distribution.gsub(/[ +]/,'_')}_distribution_presenter".camelize).safe_constantize || @default_presenter
    end
  end
```

[Examples](app/presenters)

[Documentation](http://nithinbekal.com/posts/rails-presenters/)

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
