###########################
# Last names:
# 	Avelino
# 	Balingit
# 	Liong
# 	Wong
#
# Language: Ruby
# Paradigms: functional, imperative, object-oriented, reflective
##########################

# Made by: BALINGIT, Andrei Luis
# For CSADPROG MCO1
# Simple Loan Calculator

require 'bigdecimal'

def get_positive_decimal_input(prompt)
  loop do
    print prompt
    input = BigDecimal(gets.chomp)
    return input if input > 0
    raise ArgumentError, "Input must be positive" if input <= 0
  end
end

def loan_calculator
  # init variables so that they dont go out-of-scope     (-_-)
  loan_amount = 0
  annual_interest_rate = 0
  loan_term_months = 0
  monthly_payment = 0
  total_interest = 0

  loop do
    begin
      loan_amount = get_positive_decimal_input("\nEnter Loan Amount (PHP): ")
      annual_interest_rate = get_positive_decimal_input("Enter Annual Interest Rate (%): ") / 100
      loan_term_years = get_positive_decimal_input("Enter Loan Term (Years): ").to_i
    
      loan_term_months = loan_term_years * 12
      monthly_interest_rate = annual_interest_rate / 12
      total_interest = loan_amount * monthly_interest_rate * loan_term_months
      monthly_payment = (loan_amount + total_interest) / loan_term_months
    break

    rescue ArgumentError => e
      puts "Error: #{e.message}"
    end
  end

  print "\n\tLoan Details:"
  print "\n\t\tLoan Amount: PHP #{format('%.2f', loan_amount)}"
  print "\n\t\tAnnual Interest Rate: #{format('%.2f', annual_interest_rate * 100)}%"
  print "\n\t\tLoan Term: #{loan_term_months} months"
  print "\n\t\tMonthly Repayment: PHP #{format('%.2f', monthly_payment)}"
  print "\n\t\tTotal Interest: PHP #{format('%.2f', total_interest)}\n\n"
end

# actually call on the funciton
loan_calculator