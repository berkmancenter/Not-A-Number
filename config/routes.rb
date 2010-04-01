ActionController::Routing::Routes.draw do |map|
  map.resources :branches, :collection => {:get_choices => [:get,:post]}

  map.resources :projects, :has_many => :groups, :member => {:display => [:get,:post], :display_preview => [:get,:post], :completed => [:get,:post], :assignuser => [:get,:post], :newuser => [:get,:post], :createuser => [:get,:post]}

  #map.resources :project_items

  map.resources :groups, :has_many => :questions, :member => {:toggle_active => [:get, :post]}

  #map.resources :group_items

  map.resources :questions, :has_many => [:choices, :branches], :member => {:import => [:get,:post]}
  map.resources :question_texts, :as => :questions, :controller => :questions
  map.resources :question_text_areas, :as => :questions, :controller => :questions
  map.resources :question_radios, :as => :questions, :controller => :questions
  map.resources :question_checkboxes, :as => :questions, :controller => :questions
  map.resources :question_drop_downs, :as => :questions, :controller => :questions
  map.resources :question_notes, :as => :questions, :controller => :questions
  map.resources :question_targets, :as => :questions, :controller => :questions
  map.resources :question_autocomplete_choice, :as => :questions, :controller => :questions

  #map.resources :question_items

  map.resources :choices

  map.resource :account, :controller => "users"
  map.resources :users#, :member => {:newuser => [:get,:post], :createuser => [:get,:post]}
  map.resource :user_session

  map.resources :reports, :collection => {:display => [:get,:post], :similar => [:get, :post]}

  map.resources :codes

  map.resources :targets
  map.resources :target_lists, :has_many => :targets, :member => {:import => [:get,:post]}
  
  map.root :controller => :projects, :action => :index

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

