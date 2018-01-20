require_relative '../lib/account'
require_relative '../lib/bank'
require_relative '../lib/transfer'

RSpec.configure do |config|
  config.around(:each) do |example|
    Sequel::Model.db.transaction(:rollback => :always) { example.run }
  end
end
