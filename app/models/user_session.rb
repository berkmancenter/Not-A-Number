class UserSession < Authlogic::Session::Base

  def self.oauth_consumer
    OAuth::Consumer.new("yM5O3JWGMPJveOwENu65A", "fgiAmv8QlplWUNDhiOfDUCubgOH5HVPHhrPAnzQ2Eo", {
        :site=>"http://twitter.com",
        :scheme             => :header,
        :http_method        => :post,
        :request_token_path => "/oauth/request_token",
        :access_token_path  => "/oauth/access_token",
        :authorize_path     => "/oauth/authenticate"
      })
  end
  
  def validate_by_password
    # grab the user, this actually happens again so it is
    # redundant, though the overhead shouldn't be too high
    user = search_for_record(find_by_login_method, send(login_field))
    # this is the field indicating if the user should be allowed to login
    unless user.allow_login
      # user is not allowed to login, add an error telling the user they are not allowed
      errors.add_to_base "Sorry, login has been disabled for your account"
      return
    end
    
    # user is allowed to login, call the normal base class method in
    # AuthLogic::Session::Password to actually validate the user's login
    super
  end


end