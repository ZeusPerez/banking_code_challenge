require_relative '../lib/bank_list'

describe BankList do

  it "list the banks" do
    expect(BankList.list).to be_a(Array)
  end

  describe "#add_bank" do
    it "adds a new bank to the list" do
      BankList.remove_bank("Test Bank")
      BankList.add_bank("Test Bank")
      bank_list = BankList.list
      expect(bank_list).to include("Test Bank")
    end

    it "doesn't add the bank if it is already in the list" do
      BankList.add_bank("Test Bank")
      previous_number_of_banks = BankList.list.size
      BankList.add_bank("Test Bank")
      new_number_of_banks = BankList.list.size
      expect(previous_number_of_banks).to eql(new_number_of_banks)
    end
  end

  describe "#remove_bank" do
    it "removes a bank from the list" do
      BankList.add_bank("Test Bank")
      BankList.remove_bank("Test Bank")
      bank_list = BankList.list
      expect(bank_list).not_to include("Test Bank")
    end

    it "doesn't remove the bank if it is not in the list" do
      BankList.remove_bank("Test Bank")
      previous_number_of_banks = BankList.list.size
      BankList.remove_bank("Test Bank")
      new_number_of_banks = BankList.list.size
      expect(previous_number_of_banks).to eql(new_number_of_banks)
    end
  end

end
