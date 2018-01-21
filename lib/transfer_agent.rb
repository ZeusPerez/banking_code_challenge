class TransferAgent
  def initialize(sender, receiver, amount)
    @transfer = Transfer.new(sender_id: sender, receiver_id: receiver, amount: amount)
  end

  def perform
    validate_transfer
    perform_transfer
  end

  protected

  def validate_transfer
    validate_limit
    validate_sender_balance
  end

  def perform_transfer
    begin
      Account.find(id: @transfer.sender_id).withdraw_money(@transfer.amount + @transfer.commission)
      Account.find(id: @transfer.sender_id).receive_money(@transfer.amount)
    rescue StandardError
      raise UnknownError
    end
    @transfer.save
  end

  def validate_limit
    raise(TransferLimitExceededError) if @transfer.limit < @transfer.amount && @transfer.limit > 0
  end

  def validate_sender_balance
    sender_balance = Account.find(id: @transfer.sender_id).balance
    raise(NotEnoughFunds) if sender_balance < (@transfer.amount + @transfer.commission)
  end
end

class TransferLimitExceededError < StandardError
  def initialize
    message = "The amount of the transfer is higher that the limit of this type of."
    super(message)
  end
end

class NotEnoughFunds < StandardError
  def initialize
    message = "The amount of the transfer is higher that sender current balance."
    super(message)
  end
end

class UnknownError < StandardError
  def initialize
    message = "An unknown error happened in the transfer."
    super(message)
  end
end
