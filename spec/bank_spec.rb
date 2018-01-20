require 'spec_helper'

describe Bank do

  before(:each) do
    bank_id = Bank.insert(name: "test_bank")
    @bank = Bank.find(id: bank_id)
    @anoher_bank_id = Bank.insert(name: "another_test_bank")
    @another_bank = Bank.find(id: @anoher_bank_id)
    one_account_id = Account.insert(owner: "one_test_user", bank_id: bank_id, balance: 5000)
    another_account_id =  Account.insert(owner: "another_test_user", bank_id: bank_id, balance: 8000)
    one_transfer = Transfer.insert(sender_id: one_account_id, receiver_id: another_account_id, amount: 500)
    another_transfer = Transfer.insert(sender_id: another_account_id, receiver_id: one_account_id, amount: 800)
  end

  describe "#accounts" do

    it "returns the accounts related with the bank" do
      expect(@bank.accounts.size).to eql(2)
    end

    it "returns an empty array if the bank doesn't have any account" do
      accounts = @another_bank.accounts
      expect(accounts).to be_empty
      expect(accounts).to be_a(Array)
    end
  end

  describe "#transfers" do
    it "returns the transfers related with the bank" do
      expect(@bank.transfers.size).to eql(2)
    end

    it "returns the transfer related with the bank without the ones not related with the bank" do
      third_account_id = Account.insert(owner: "third_test_user", bank_id: @anoher_bank_id, balance: 5000)
      fourth_account_id = Account.insert(owner: "fourth_test_user", bank_id: @anoher_bank_id, balance: 5000)
      third_transfer = Transfer.insert(sender_id: third_account_id, receiver_id: fourth_account_id, amount: 500)
      expect(@bank.transfers.size).to eql(2)
    end
  end

  describe "#print_transfers" do
    it "prints the transfer history" do
      expect { @bank.print_transfers }.to output(/20\/01\/2018 11:23AM \/ 3 \/ 2 \/ 800.0/).to_stdout
    end
  end
end
