class ReportsController < ApplicationController
  def avg_infected
    render json: {
      description: "Average of infected people",
      percentage: Survivor.avg_infected
    }
  end
  def avg_non_infected
    render json: {
      description: "Average of non-infected people",
      percentage: Survivor.avg_non_infected
    }
  end
  def avg_resource_per_person
    render json: {
      description: "Average of resources per person",
      avg_ammunition: Survivor.avg_resource_per_person(1),
      avg_medication: Survivor.avg_resource_per_person(2),
      avg_food: Survivor.avg_resource_per_person(3),
      avg_water: Survivor.avg_resource_per_person(4),
    }
  end
  def points_lost_infected
    render json: {
      description: "Total points lost in resources that belong to infected people",
      number: Survivor.points_lost_infected
    }
  end
end
