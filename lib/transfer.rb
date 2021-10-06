class Transfer

  @@all = []

  def self.all
    @@all
  end

  def self.clear
    self.all.clear
  end

  attr_accessor :status
  attr_reader :sender, :receiver, :amount

  def initialize(sender, receiver, amount = 50)
    @sender, @receiver, @amount = sender, receiver, amount
    @status = "pending"
  end

  def save
    self.class.all << self
  end

  def valid?
    self.receiver.valid? && self.sender.valid?
  end

  def execute_transaction
    if self.unique? && self.valid? && self.sender_has_funds?
      self.receiver.balance += self.amount
      self.sender.balance -= self.amount
      self.status = "complete"
      self.save
    else
      self.status = "rejected"
      "Transaction rejected. Please check your account balance."
    end
  end

  def unique?
    !self.class.all.include?(self) ? true : false
  end

  def sender_has_funds?
    self.sender.balance >= self.amount
  end

  def reverse_transfer
    if !self.unique?
      self.receiver.balance -= self.amount
      self.sender.balance += self.amount
      self.status = "reversed"
      self.class.clear
    end
  end

end

