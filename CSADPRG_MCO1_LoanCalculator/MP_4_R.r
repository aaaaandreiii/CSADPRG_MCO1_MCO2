###########################
# Last names:
# 	Avelino
# 	Balingit
# 	Liong
# 	Wong
#
# Language: R
# Paradigm(s): Functional, Procedural
##########################

get_numeric_input <- function(prompt) {
  repeat {
    print(prompt)
    input <- readline()
    numeric_value <- as.numeric(input)
    if (!is.na(numeric_value)) {
      return(numeric_value)
    } else {
      print("Invalid input. Please enter a numeric value.")
    }
  }
}

loan <- get_numeric_input("Input Loan Amount:")
rate <- get_numeric_input("Annual Interest Rate:")
term <- get_numeric_input("Loan Term (in years):")

rate <- rate / 100
mir <- rate / 12

term_months <- term * 12

totalRate <- loan * mir * term_months
repayment <- (loan + totalRate) / term_months

print(paste("Loan Amount: PHP", loan))
print(paste("Annual Interest Rate:", rate * 100, "%"))
print(paste("Loan Term:", term_months, "months"))
print(paste("Monthly Repayment: PHP", round(repayment, 2)))
print(paste("Total Interest: PHP", round(totalRate, 2)))

