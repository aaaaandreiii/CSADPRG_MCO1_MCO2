/*
*******************************
Last names:

	Avelino
	Balingit
	Liong
	Wong

Language: Go
Paradigm(s): Imperative, Structured, Concurrent
*******************************
*/
package main

import (
	"fmt"
	"log"
)

func main() {
	var LAMT float64
	var RATE_YEAR, RATE_MONTH float64
	var LTERM_YEAR, LTERM_MONTH, REPAY, TINTEREST float64
	fmt.Print("Loan Amount: PHP ")
	_, err := fmt.Scan(&LAMT)
	if err != nil {
		log.Fatal("\nError while scanning.")
	}
	for LAMT < 0 {
		fmt.Print("\nInvalid Input, please input again: ")
		_, err = fmt.Scan(&LAMT)
		if err != nil {
			log.Fatal("\nError while scanning.")
		}
	}
	fmt.Print("Annual Interest Rate: ")
	_, errs := fmt.Scan(&RATE_YEAR)
	if errs != nil {
		log.Fatal("\nError while scanning.")
	}
	for RATE_YEAR < 0 {
		fmt.Print("\nInvalid Input, please input again: ")
		_, err = fmt.Scan(&RATE_YEAR)
		if err != nil {
			log.Fatal("\nError while scanning.")
		}
	}
	fmt.Print("Loan Term: ")
	_, errors := fmt.Scan(&LTERM_YEAR)
	if errors != nil {
		log.Fatal("\nError while scanning.")
	}
	for LTERM_YEAR < 0 {
		fmt.Print("\nInvalid Input, please input again: ")
		_, err = fmt.Scan(&LTERM_YEAR)
		if err != nil {
			log.Fatal("\nError while scanning.")
		}
	}
	RATE_MONTH = RATE_YEAR / 12
	LTERM_MONTH = LTERM_YEAR * 12
	TINTEREST = LAMT * (RATE_MONTH / 100) * LTERM_MONTH
	REPAY = (LAMT + TINTEREST) / LTERM_MONTH
	fmt.Println("Loan Amount: PHP ", LAMT)
	fmt.Println("Annual Interest Rate: ", RATE_YEAR, "%")
	fmt.Println("Loan Term: ", LTERM_MONTH, " months")
	fmt.Println("Monthly Repayment: PHP ", REPAY)
	fmt.Println("Total Interest: PHP ", TINTEREST)
}
