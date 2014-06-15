require File.expand_path('../../validator.rb', __FILE__)
Dir[File.dirname(__FILE__) + '/shared_examples/*.rb'].each { |file| require file }

include CV

