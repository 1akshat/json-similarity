Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'json_similarity#index'

  # API END POINTS
  post 'compare_json_files' => 'json_similarity#compare_json_files', format: :json
end
