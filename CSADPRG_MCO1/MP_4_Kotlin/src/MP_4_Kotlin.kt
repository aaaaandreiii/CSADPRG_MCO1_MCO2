/*
********************
Last names:
*   Avelino
*   Balingit
*   Liong
*   Wong
Language: Kotlin
Paradigm(s): functional, imperative, object-oriented, procedural
********************
 */
fun main() {
    var loanAmount: Double
    var annualInterestRate: Double
    var loanTerm: Double
    do{
        print("Loan Amount: PHP ")
        loanAmount = readln().toDoubleOrNull() ?: -1.0
        if(loanAmount <= 0){
            println("Please input valid loan amount in PHP.")
        }
    }while(loanAmount <= 0)
    do{
        print("Annual Interest Rate (%): ")
        annualInterestRate = readln().toDoubleOrNull() ?: -1.0
        if(annualInterestRate <= 0){
            println("Please input valid annual interest rate in %.")
        }
    }while(annualInterestRate <= 0)
    do{
        print("Loan Term (Years): ")
        loanTerm = readln().toDoubleOrNull() ?: -1.0
        if(loanTerm <= 0){
            println("Please input valid loan term in YEARS.")
        }
    }while(loanTerm <= 0)

    val monthlyInterestRate = annualInterestRate/100/12
    val loanTermMonths = (loanTerm*12).toInt()
    val totalInterest = loanAmount*monthlyInterestRate*loanTermMonths
    val monthlyRepayment = (loanAmount+totalInterest)/loanTermMonths

    println("Loan Amount: PHP ${"%,.2f".format(loanAmount)}")
    println("Annual Interest Rate: ${"%.2f".format(annualInterestRate)} %")
    println("Loan Term: $loanTermMonths months")
    println("Monthly Repayment: PHP ${"%,.2f".format(monthlyRepayment)}")
    println("Total Interest: PHP ${"%,.2f".format(totalInterest)}")
}