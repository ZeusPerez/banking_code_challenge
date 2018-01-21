require 'sequel'

DB = Sequel.connect('sqlite://banks.db')

class TransferConfig < Sequel::Model; end

class Transfer < Sequel::Model
  many_to_one :account
  def before_create
    super
    if Account.find(id: sender_id).bank_id == Account.find(id: receiver_id).bank_id
      self.type = "intra-bank"
    else
      self.type = "inter-bank"
    end
  end

  def limit
    TransferConfig.find(type: self.type).limit
  end

  def commission
    TransferConfig.find(type: self.type).commission
  end
end
