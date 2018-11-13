module InvestmentPerformer

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def sfrp
      Investment.single_family_rental_properties
    end
  end

  def total_distribution
    distribution_years.joins(:distributions).sum('distributions.amount')
  end

  def progresses_with_order
    progresses.order(development? ? 'progresses.updated DESC' : 'progresses.year DESC, progresses.quarter DESC')
  end

  def sfrp?
    single_family_rental_properties?
  end

  def rental_properties?
    multi_family? || sfrp?
  end

  def total_distribution_for_year(year)
    distribution_years.where(['year = ?', year]).joins(:distributions).sum('distributions.amount')
  end

  def next_image_order
    last_image = images.order(order: :asc).last
    last_image ? last_image.order + 1 : 0
  end

  def reconstruct_order
    images.order(order: :asc).each_with_index do |image, index|
      image.order = index unless image.order == index
      image.save
    end
  end

  def table_color
    completed? ? 'green' : 'blue'
  end

  def progress_quarters
    output = []
    progresses.each do |progress|
      quarter = CalendarQuarter.new(progress.raw_quarter + 1, progress.year)
      output << quarter unless output.include? quarter
    end
    output.sort.reverse
  end

  def full_name
    complex_name.present? ? name.to_s + ' - ' + complex_name.to_s : name
  end

  def current_stage?(stage)
    stage.stage.include?(timeline)
  end

  def current_stage
    stages.find_by(stage: Investment.timelines[timeline])
  end

end
