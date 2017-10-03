module Docs
  module SurvivorsController
    extend ActiveSupport::Concern

    included do
      swagger_schema :Survivor do
        key :required, [:name, :age, :gender, :longitude, :latitude]
        key :uniquess, [:name]
        property :id do
          key :type, :integer
        end
        property :name do
          key :type, :string
        end
        property :age do
          key :type, :integer
        end
        property :gender do
          key :type, :string
        end
        property :latitude do
          key :type, :string
        end
        property :longitude do
          key :type, :string
        end
        property :infected do
          key :type, :boolean
        end
        property :infection_occurences do
          key :type, :integer
        end
      end
      swagger_path '/surivors/{id}' do
        operation :get do
          key :summary, 'Find Survivor by ID'
          key :tags, [
            'survivor'
          ]
          parameter do
            key :name, :id
            key :description, 'ID of survivor to fetch'
            key :required, true
            key :type, :integer
          end
          response 200 do
            key :description, 'survivor found!'
          end
          response 404 do
            key :description, 'survivor don\'t found'
          end
        end
      end
      swagger_path '/pets' do
        operation :get do
          key :summary, 'All Survivors'
          key :description, 'Returns all survivors from the system'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'survivor'
          ]
          response 200 do
            key :description, 'survivor response'
          end
        end
        operation :delete do
          key :description, 'Delete a specific survivor'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'pet'
          ]
          parameter do
            key :name, :id
            key :in, :body
            key :description, 'Find a survivor and delete'
            key :required, true
          end
          response 200 do
            key :description, 'survivor response'
          end
          response 404 do
            key :description, 'survivor don\'t found'
          end
        end
      end
    end

  end
end
