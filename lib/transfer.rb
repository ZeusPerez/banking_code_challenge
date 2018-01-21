require 'sequel'

DB = Sequel.connect('sqlite://banks.db')

class TransferConfig < Sequel::Model; end

class Transfer < Sequel::Model
  many_to_one :account
  def initialize(params = {})
    super
    self.type = if Account.find(id: sender_id).bank_id == Account.find(id: receiver_id).bank_id
                  "intra-bank"
                else
                  "inter-bank"
                end
  end

  def limit
    TransferConfig.find(type: self.type).limit
  end

  def commission
    TransferConfig.find(type: self.type).commission
  end
end
