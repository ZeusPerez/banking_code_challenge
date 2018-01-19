require 'yaml'

module BankList

  def self.list
    YAML.load(File.read(self.banks_file))
  end

  def self.add_bank(bank_name)
    new_bank_list = self.list.push(bank_name)
    self.write_banks_file(new_bank_list)
  end

  def self.remove_bank(bank_name)
    new_bank_list = self.list.delete_if { |element| element == bank_name }
    self.write_banks_file(new_bank_list)
  end

  protected

  def self.write_banks_file(new_bank_list)
    File.write(self.banks_file, new_bank_list.uniq.to_yaml)
  end

  def self.banks_file
    "assets/bank_list.yml"
  end

end
