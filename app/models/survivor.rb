class Survivor < ApplicationRecord
  has_one :inventory
  has_many :inventory_resources, through: :inventory

  accepts_nested_attributes_for :inventory

  validates :name, :age, :gender, :longitude, :latitude, presence: true
  validates :name, uniqueness: true

  # validates :inventory, presence: true

  scope :all_peoples, -> { all }
  scope :infected_peoples, -> { where("infected = ?", true) }
  scope :no_infected_peoples, -> { where("infected = ?", false) }

  def report_infection
    self.infection_occurrences += 1
    infect if infections_rate_reached?
  end

  def self.avg_infected
    (infected_peoples.count.to_f / all_peoples.count.to_f)*100
  end

  def self.avg_non_infected
    (no_infected_peoples.count.to_f / all_peoples.count.to_f)*100
  end

  def self.avg_item_per_person(id)
    count_item_in_inventory(id) / all_peoples.count.to_f
  end

  def self.points_lost_infected
    number_points_of(infected_peoples)
  end

  private

  def infections_rate_reached?
    infection_occurrences == 3
  end

  def infect
    self.infected = true
  end

  def self.count_item_in_inventory(id)
    InventoryResource.where(resource_id: id).count
  end

  def self.number_points_of(peoples)
    points = 0
    peoples.map { |p|
      p.inventory.resources.map { |r|
        points += r.point
      }
    }
    points
  end
end
