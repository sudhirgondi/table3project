class Event < ActiveRecord::Base
	validates :name, :description, :location, :address, presence:true
	has_many :posts,:dependent=>:destroy
	has_many :users, through: :event_attendants
	belongs_to :interest
end