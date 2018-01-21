require 'spec_helper'

describe TransferAgent do
  let(:bank_id) { Bank.insert(name: "test_bank") }
  let(:another_bank_id) { Bank.insert(name: "another_test_bank") }
  let(:one_account_id) { Account.insert(owner: "one_test_user", bank_id: bank_id, balance: 5_000) }
  let(:another_account_id) { Account.insert(owner: "another_test_user", bank_id: bank_id, balance: 1_001) }
  let(:third_account_id) { Account.insert(owner: "third_test_user", bank_id: another_bank_id, balance: 1_000) }
  let(:inter_bank_transfer) { Transfer.new(sender_id: one_account_id, receiver_id: another_account_id, amount: 500).save }

  describe "#perform" do
    it "raises an error when the limit is overpassed" do
      transfer_agent = TransferAgent.new(one_account_id, third_account_id, 2_000)
      expect { transfer_agent.perform }.to raise_error(TransferLimitExceededError)
    end

    it "raises an error when the balance in the sender is not enough" do
      transfer_agent = TransferAgent.new(another_account_id, third_account_id, 1_000)
      expect { transfer_agent.perform }.to raise_error(NotEnoughFunds)
    end

    it "perform an interbank transfer" do
      allow_any_instance_of(Account).to receive(:withdraw_money).with(1_005)
      allow_any_instance_of(Account).to receive(:receive_money).with(1_000)
      transfer_agent = TransferAgent.new(one_account_id, third_account_id, 1_000)
      transfer_agent.perform
    end

    it "perform an intrabank transfer" do
      allow_any_instance_of(Account).to receive(:withdraw_money).with(1_000)
      allow_any_instance_of(Account).to receive(:receive_money).with(1_000)
      transfer_agent = TransferAgent.new(one_account_id, another_account_id, 1_000)
      transfer_agent.perform
    end

    it "raises an error for unknown error in the transfer" do
      allow_any_instance_of(Account).to receive(:withdraw_money).with(1_005).and_raise("error")
      transfer_agent = TransferAgent.new(one_account_id, third_account_id, 1_000)
      expect { transfer_agent.perform }.to raise_error(UnknownError)
    end
  end
end
