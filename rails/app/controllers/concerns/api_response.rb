# This module allow to define a layout + data for XML/JSON output.
class ApiResponse
  extend ActiveSupport::Concern

  # Define in application controller a singleton methods like this :
  # def api_response
  #   @api_response ||= ApiResponse.new(params)
  # end
  def initialize(params)
    @offset            = params[:offset].to_i || 0, # params[:offset] -> better
    @limit             = params[:limit] || 25, # params[:limit] should be better
    @total_records     = 0,
    @response_records  = 0,
    @data              = [],
    @order             = params[:order] || 'id',
    @direction         = params[:direction] || 'ASC'

    # Status to return like :created, :unprocessable_entity, :nok...
    @status          = :ok
  end

  # Insert datas to response from your controller's action
  def add_data(data)
    @data.merge! data
  end

  # By passing options, you can override the render options
  # Redefine the request status, add a location, etc...
  def render(options = {})
    define_status!
    rendering_options = { status: @status }.merge options

    respond_to do |format|
      # Instance variables are available on view
      # as we are in a controller concern
      format.html
      # Other formats
      format.json { render self.to_hash.to_json, rendering_options }
      format.xml  { render self.to_hash.to_xml,  rendering_options }
      # CSV aren't respresented as a schema
      format.csv  { render @data.to_csv,      rendering_options }
    end
  end

  protected

  # Method to define the common hash structure of the response
  def to_hash(opts = {})
    {
      offset:             @offset,
      limit:              @limit,
      total_records:      @model.count, # TODO : Create an helper method to get current model total records
      response_records:   @data.count,
      data:               @data,
      order:              @order,
      direction:          @direction
    }
  end

  private

  # If there is error in records, change status to the commonly used in controllers
  def define_status!
    if @data.any? { |r| r.respond_to? :errors && not r.errors.empty?  }
      @status = :nok
    end
  end
end
