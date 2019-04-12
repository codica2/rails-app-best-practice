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

  def creation_date
    object.created_at.strftime('%d/%m/%Y')
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
class Subscribe < BaseService

  attr_reader :email

  def initialize(email)
    @email = email
  end

  def call
    list.members.create(body: { email_address: email, status: 'subscribed' })
  end

  private

  def list
    gibbon_request.lists(ENV['MAILCHIMP_LIST_ID'])
  end

  def gibbon_request
    Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
  end

end
```
[Examples](app/services)

## Presenters
Presenters give you an object oriented way to approach view helpers.

```ruby
class QuarterlyDistributionPresenter < BaseDividendYearPresenter

  QUARTERS = %w[Q1 Q2 Q3 Q4].freeze

  def dividends_year
    QUARTERS.map do |quarter|
      value_decorator(quarter)
    end
  end

  def select_dividend_by(dividend_year)
    CalendarQuarter.from_date(dividend_year).quarter
  end

end
```

[Examples](app/presenters)

[Documentation](http://nithinbekal.com/posts/rails-presenters/)

## Facades

Facades provide a unified interface to a set of interfaces in a subsystem. Facade defines a higher-level interface that makes the subsystem easier to use.
One of the responsibilities that is being thrown at the controller is to prepare the data so it can be presented to user. To remove the responsibility of preparing the data for the view we're using Facade pattern.

```ruby
class Admin

  class DocumentsFacade

    attr_reader :loan, :investor

    def initialize(loan_id, investor_id)
      @loan     = Loan.find(loan_id)
      @investor = Investor.find(investor_id)
    end

    def lender?
      investor.present?
    end

    def documents
      Document.where(investment_id: loan.id, investor_id: investor.id)
    end

    def lenders
      loan.lenders.order(:name).uniq.collect { |l| [l.name, l.id] }
    end

  end

end
```

Now we can reduce our controller down to:

```ruby
class DocumentsController < LoansController

  def index
    add_breadcrumb 'Documents'
    @documents_data = Admin::DocumentsFacade.new(params[:loan_id], params[:investor_id])
  end

end
```

And inside our view we will call for our facade:

```slim
= render ‘documents/form’, document: @document_data.new_document
```

[Examples](app/facades)

[Documentation](https://medium.com/kkempin/facade-design-pattern-in-ruby-on-rails-710aa88326f)

## Workers
At Codica we use sidekiq as a full-featured background processing framework for Ruby. It aims to be simple to integrate with any modern Rails application and much higher performance than other existing solutions.

```ruby
class PartnerAlertWorker

  include Sidekiq::Worker

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
  let(:listing) { create :listing }

  scenario 'unsuccess payment' do
    visit payment_info_error_path(listing: listing.id)
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
rails-app-best-practice is Copyright © 2015-2019 Codica. It is released under the [MIT License](https://opensource.org/licenses/MIT).

## About Codica

[![Codica logo](https://www.codica.com/assets/images/logo/logo.svg)](https://www.codica.com)

We love open source software! See [our other projects](https://github.com/codica2) or [hire us](https://www.codica.com/) to design, develop, and grow your product.
