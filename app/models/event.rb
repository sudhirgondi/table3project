class Event < ActiveRecord::Base
	validates :name, :description, :location, :address,:city,:state,:zip_code, presence:true
	has_many :event_attendants
	has_many :posts,:dependent=>:destroy
	has_many :users, through: :event_attendants
	belongs_to :interest

	geocoded_by :location
 	after_validation :geocode, :if => :location_changed?

 	acts_as_gmappable :process_geocoding => false

 	def location
 		[address,city,state,zip_code].compact.join(',')
 	end

	def gmaps4rails_address
	#describe how to retrieve the address from your model, if you use directly a db column, you can dry your code, see wiki
	  "#{self.address}, #{self.city}, #{self.state} #{self.zip_code}" 
	end
	 def gmaps4rails_title
      "#{self.name}"
    end
	def gmaps4rails_infowindow
      "<h4>#{self.address},#{self.city}, #{self.state}, #{self.zip_code}</h4>"
  	end
	def gmaps4rails_sidebar
	  "<span class='foo'>#{self.name}</span>" #put whatever you want here
	end
end