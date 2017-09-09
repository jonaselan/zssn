class DocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'ZSSN'
      key :description, 'System for help non-infected peoples to share resources'
      contact do
        key :name, 'Jonas Elan'
        key :email, 'jonas.elan@gmail.com'
      end
    end
    tag do
      key :name, 'survivor'
      key :description, 'Survivor from apocalypse zumbi'
    end
    key :basePath, '/api'
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    SurvivorsController,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
