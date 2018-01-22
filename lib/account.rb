require 'sequel'

DB = Sequel.connect('sqlite://banks.db')

class Account < Sequel::Model
  many_to_one :author
  plugin :validation_helpers
  def validate
    validates_unique :owner
  end

  def withdraw_money(quantity)
    raise(NotEnoughMoneyError) if self.balance < quantity
    new_balance = self.balance - quantity
    self.update(balance: new_balance)
  end

  def receive_money(quantity)
    new_balance = self.balance + quantity
    self.update(balance: new_balance)
  end

  def print_balance
    puts
    puts "Balance of the account #{self.id}"
    puts "================================="
    puts self.balance
  end
end

class NotEnoughMoneyError < StandardError
  def initialize
    message = "The account does not have enough money to do this transaction."
    super(message)
  end
end
