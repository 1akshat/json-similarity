class HomeController < ApplicationController

  include HomeHelper

  def index
  end

  def compare_json_files
    @matched_values = 0
    @unmatched_values = 0

    file1_data = read_file "./config/data/BreweriesSample2.json"
    file1_data = params[:file1_data] if params[:file1_data].present?
    file2_data = read_file "./config/data/BreweriesSample3.json"
    file2_data = params[:file2] if params[:file2].present?
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
