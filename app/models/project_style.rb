# == Schema Information
# Schema version: 20090903160209
#
# Table name: project_styles
#
#  id         :integer(4)      not null, primary key
#  project_id :integer(4)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProjectStyle < ActiveRecord::Base
  belongs_to :project
end
