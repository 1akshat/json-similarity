class JsonSimilarityController < ApplicationController

  skip_before_action :verify_authenticity_token

  include JsonSimilarityHelper

  def index
  end

  def compare_json_files
    @matched_values = 0
    @unmatched_values = 0
    if params[:file1_data].present?
      file1_data = params[:file1_data].as_json
    else
      raise "No Input Present."
    end
    if params[:file2_data].present?
      file2_data = params[:file2_data].as_json 
    else
      raise "No Input Present."
    end
    standard_response = {}
    begin
      data = compare_hashes(file1_data, file2_data)
      standard_response['success'] = true
      standard_response['at'] = Time.now
      standard_response['errors'] = []
      standard_response['result'] = {
        :score => data
      }
    rescue Exception => e
      standard_response['success'] = false
      standard_response['at'] = Time.now
      standard_response['errors'] = [e]
    end
    render json: standard_response
  end

end
