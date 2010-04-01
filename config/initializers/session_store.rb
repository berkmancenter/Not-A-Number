# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Not_A_Number_session',
  :secret      => 'b0160e53522a5ae062533b3d3570219ebbc3819cf1bf6a20d4b713ef8af7d17757135909370d0a29a1e4e34f6c7b9930804e47afed977e4e0e4a4cae9eba6661'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
