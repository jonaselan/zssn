class SurvivorsController < ApplicationController
  before_action :get_survivor, only: [:show, :update, :destroy, :report_infection]

  def report_infection
    unless @survivor.infected
      @survivor.report_infection
      @survivor.save
      render json: { message:  "Flag the survivor!"}
    else
      render json: { message:  "Already dead :("}
    end
  end

  def index
    @survivors = Survivor.all

    render json: @survivors
  end

  def show
    render json: @survivor
  end

  def create
    @survivor = Survivor.new(survivor_params)
    if @survivor.save
      render json: @survivor, status: :created, location: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def update
    if @survivor.update(survivor_params)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @survivor.destroy
  end

  private
    def get_survivor
      @survivor = Survivor.find(params[:id])
    end

    def survivor_params
      params.permit(:name, :age, :gender, :latitude, :longitude, :infected, :infection_occurrences,
                      inventory_attributes: [
                        inventory_resources_attributes: [ 
                          :resource_id
                        ]
                      ]
                    )
    end
end
