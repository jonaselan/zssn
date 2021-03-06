class Survivor < ApplicationRecord
  has_one :inventory
  has_many :inventory_resources, through: :inventory

  accepts_nested_attributes_for :inventory

  validates :name, :age, :gender, :longitude, :latitude, presence: true
  validates :name, uniqueness: true

  scope :all_people, -> { all }
  scope :infected_people, -> { where("infected = ?", true) }
  scope :no_infected_people, -> { where("infected = ?", false) }

  def report_infection
    self.infection_occurrences += 1
    infect if infections_rate_reached?
  end

  def do_the_trade_with(other, resources)
    resources.split(',').each do |r|
      values = r.split(':')
      (values[0].to_i).times do |t|
        resource = Resource.by_name(values[1])
        other.inventory.inventory_resources.create(resource: resource)
        InventoryResource.where(resource: resource, inventory: self.inventory).first.destroy
      end
    end
  end

  def self.avg_infected
    (infected_people.count.to_f / all_people.count.to_f)*100
  end

  def self.avg_non_infected
    (no_infected_people.count.to_f / all_people.count.to_f)*100
  end

  def self.avg_resource_per_person(id)
    count_resource_in_inventory(id) / all_people.count.to_f
  end

  def self.points_lost_infected
    number_points_of(infected_people)
  end

  private

  def infections_rate_reached?
    infection_occurrences == 3
  end

  def infect
    self.infected = true
  end

  def self.count_resource_in_inventory(id)
    InventoryResource.where(resource_id: id).count
  end

  def self.number_points_of(people)
    points = 0
    people.map { |p|
      p.inventory.resources.map { |r|
        points += r.point
      }
    }
    points
  end
end
