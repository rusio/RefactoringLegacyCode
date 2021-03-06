class ValuesOfMonth
  attr_reader :date_of_month, :transactions_of_month, :preceding_balance
  private :date_of_month, :transactions_of_month, :preceding_balance

  def initialize(date_of_month = Date.today, transactions_of_month = [], preceding_balance = 0)
    @balance = 0
    @date_of_month = date_of_month
    @transactions_of_month = transactions_of_month
    @preceding_balance = preceding_balance
  end

  def set_balance_and_average(balance, average_balance)
    @balance = balance
    @average_balance = average_balance
  end

  def balance
    calculate_values
    @balance
  end

  def average_balance
    calculate_values
    Integer(@average_balance)
  end

  def calculate_values
    balance = preceding_balance
    ultimo = date_of_month.day

    average_balance = 0.0
    day_of_latest_balance = 1
    transactions_of_month.each do |transaction|
      day = transaction.date.day
      average_balance += calculate_proportional_balance(day_of_latest_balance, balance, day, ultimo)
      balance += transaction.amount
      day_of_latest_balance = day
    end
    average_balance += calculate_proportional_balance(day_of_latest_balance, balance, ultimo + 1, ultimo)
    set_balance_and_average(balance, average_balance)
  end

  private
  def calculate_proportional_balance(day_of_latest_balance, balance, day, days_in_month)
    counting_days = day - day_of_latest_balance
    return 0 if counting_days == 0
    rate = counting_days.to_f / days_in_month.to_f
    balance * rate
  end
end
