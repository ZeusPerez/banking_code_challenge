require 'sequel'

DB = Sequel.connect('sqlite://banks.db')

class Bank < Sequel::Model
  plugin :validation_helpers
  def validate
    validates_unique :name
  end

  def accounts
    Account.where(bank_id: self.id).all
  end

  def transfers
    account_ids = accounts.map(&:id)
    Transfer.all.select do |transfer|
      account_ids.include?(transfer.sender_id) || account_ids.include?(transfer.receiver_id)
    end
  end

  def print_transfers
    transfer_history = transfers.sort_by { |transfer| transfer.transfer_date }.reverse
    puts
    puts "TRANSFER HISTORY of #{self.name} (date / sender / receiver / amount)"
    puts "===================================================================="
    transfer_history.each do |transfer|
      puts [transfer.transfer_date.strftime("%d/%m/%Y %I:%M%p"),
         transfer.sender_id,
         transfer.receiver_id,
         transfer.amount].join(" / ")
    end
  end
end
