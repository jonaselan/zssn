class SurvivorsController < ApplicationController
  include Swagger::Blocks
  include Docs::SurvivorsController

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

  def trade
    begin
      data = info_trade
    rescue ActiveRecord::RecordNotFound
      return render json: { message: "Survivor not exist" }
    end

    begin
      if TradeService.is_a_valid_trade?(data)
        TradeService.make_the_trade(data)
        render json: { message: "Trade finished!" }
      else
        render json: { message: "Resource's points don't match or exist one person infected" }, status: 400
      end
    rescue NoMethodError
      render json: { message: "Resource not found" }
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
      params
        .permit(:id, :name, :age, :gender, :latitude, :longitude, :infected, :infection_occurrences,
                  inventory_attributes: [
                    inventory_resources_attributes: [
                      :resource_id
                    ]
                  ]
                )
    end

    def info_trade
      {
        survivor1: Survivor.find(params[:survivor1_id]),
        survivor2: Survivor.find(params[:survivor2_id]),
        resources1: params[:resources1],
        resources2: params[:resources2]
      }
    end
end
