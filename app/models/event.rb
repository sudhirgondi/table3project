class Event < ActiveRecord::Base
	has_many :posts,:dependent=>:destroy
	has_many :users, through: :event_attendants
	belongs_to :interest
	
	validates :name, :description, :location, :address, presence:true
	validates :zip_code,  :presence => true, :numericality => { :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999, :message => "must be valid." }
end