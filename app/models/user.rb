class User < ActiveRecord::Base
  attr_accessor :password

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :first_name, :last_name,		:presence 	=> true,
  					:length		            => { :maximum => 50 }
  validates :email_address,		:presence		=> true,
  					:format		            => { :with => email_regex },
           	:uniqueness 	        => { :case_sensitive => false }

  validates :password, 	:presence => true,
  	   			:confirmation 	      => true,
  					:length			          => { :within => 6..40 }

  validates :password_confirmation,  :presence => true
  validates :zip_code,  :presence => true, :numericality => { :greater_than_or_equal_to => 10000, :less_than_or_equal_to => 99999, :message => "must be valid." }


  before_save :encrypt_password, :upcase_first_word

  def has_password?(submitted_password)
  	encrypted_password == encrypt(submitted_password)
  end


  # class method that checks whether the user's email and submitted_password are valid
  def self.authenticate(email, submitted_password)
    user = find_by_email_address(email)

   	return nil if user.nil?
   	return user if user.has_password?(submitted_password)
  
  end


  private
    def upcase_first_word
      f = self.first_name
      l = self.last_name
      f[0] = f.first.upcase!
      f.to_s
      l[0] = l.first.upcase!
      l.to_s
    end

  	def encrypt_password
  		# generate a unique salt if it's a new user
  		self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if self.new_record?
  	
  		# encrypt the password and store that in the encrypted_password field
  		self.encrypted_password = encrypt(password)
  	end

  	# encrypt the password using both the salt and the passed password
  	def encrypt(pass)
  		Digest::SHA2.hexdigest("#{self.salt}--#{pass}")
  	end
end
