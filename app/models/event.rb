class Event < ActiveRecord::Base
	has_many :posts,:dependent=>:destroy
	has_many :event_attendants
	has_many :users, through: :event_attendants

	belongs_to :interest

	geocoded_by :address
 	after_validation :geocode, :if => :address_changed?

	validates :name, :description, :location, :address, presence:true
	# validates :zip_code, :numericality => { :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999, :message => "must be valid." }
end