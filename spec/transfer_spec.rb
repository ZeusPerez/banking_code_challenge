require 'spec_helper'

describe Transfer do
  let(:bank_id) { Bank.insert(name: "test_bank") }
  let(:another_bank_id) { Bank.insert(name: "another_test_bank") }
  let(:one_account_id) { Account.insert(owner: "one_test_user", bank_id: bank_id, balance: 5_000) }
  let(:another_account_id) { Account.insert(owner: "another_test_user", bank_id: bank_id, balance: 8_000) }
  let(:third_account_id) { Account.insert(owner: "third_test_user", bank_id: another_bank_id, balance: 1_000) }

  describe "#" do
    it "creates a intra-bank transfer" do
      transfer = Transfer.new(sender_id: one_account_id, receiver_id: another_account_id, amount: 500).save
      expect(transfer.type).to eql("intra-bank")
    end

    it "creates a inter-bank transfer" do
      transfer = Transfer.new(sender_id: one_account_id, receiver_id: third_account_id, amount: 500).save
      expect(transfer.type).to eql("inter-bank")
    end
  end
end
