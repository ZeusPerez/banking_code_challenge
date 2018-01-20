require 'spec_helper'

describe Account do

  let(:account) { Account.new(owner: "test_user", bank_id: 1, balance: 25000) }

  describe "#withdraw_money" do

    it "substracts the money from the balance" do
      allow(account).to receive(:update).with(balance: 24800)
      account.withdraw_money(200)
    end

    it "raises an error when there is not enough money" do
      expect { account.withdraw_money(26000) }.to raise_error(NotEnoughMoneyError)
    end
  end

  describe "#receive_money" do
    it "adds the money to the balance" do
      allow(account).to receive(:update).with(balance: 25200)
      account.receive_money(200)
    end
  end
end
