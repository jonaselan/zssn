class Survivor < ApplicationRecord
  has_one :inventory
  has_many :inventory_resources, through: :inventory

  accepts_nested_attributes_for :inventory

  validates :name, :age, :gender, :longitude, :latitude, presence: true
  validates :name, uniqueness: true

  def report_infection
    self.infection_occurrences += 1
    infect if infections_rate_reached?
  end

  private

  def infections_rate_reached?
    infection_occurrences == 3
  end

  def infect
    self.infected = true
  end
  
end
