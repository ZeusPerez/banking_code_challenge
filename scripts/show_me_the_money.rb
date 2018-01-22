require_relative '../lib/account'
require_relative '../lib/bank'
require_relative '../lib/transfer'
require_relative '../lib/transfer_agent'

def print_information(account)
  puts "############################"
  puts "#{account.owner} information"
  puts "############################"
  account.print_balance
  Bank.find(id: account.bank_id).print_transfers
end

def main_scenario
  jim_account = Account.find(owner: "Jim")
  emma_account = Account.find(owner: "Emma")

  puts
  puts "BEFORE THE TRANSFER"

  print_information(jim_account)
  print_information(emma_account)

  TransferAgent.new(jim_account.id, emma_account.id, 20_000).perform

  puts
  puts "AFTER THE TRANSFER"

  print_information(jim_account)
  print_information(emma_account)
end


main_scenario
