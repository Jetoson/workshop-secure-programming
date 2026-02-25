#include <stdio.h>

/*
 * Exercise 08 - Negative Amount: FIXED VERSION
 *
 * Fix: Validate that the transfer amount is strictly positive before
 *      proceeding. This prevents the logic flaw where a negative amount
 *      passes the balance check and effectively adds funds.
 */

static int balance = 1000;

static void show_balance(void)
{
	printf("Current balance: %d coins\n", balance);
}

static void transfer(int amount)
{
	/* SECURE: reject non-positive amounts before any further logic */
	if (amount <= 0) {
		printf("[-] Invalid amount: transfers must be a positive number.\n");
		return;
	}

	if (balance >= amount) {
		balance -= amount;
		printf("[+] Transferred %d coins. New balance: %d\n", amount, balance);
	} else {
		printf("[-] Insufficient funds. Balance: %d, requested: %d\n",
				balance, amount);
	}
}

int main(void)
{
	show_balance();

	printf("Enter transfer amount: ");
	fflush(stdout);

	int amount;
	if (scanf("%d", &amount) != 1) {
		printf("[-] Invalid input.\n");
		return 1;
	}

	transfer(amount);
	show_balance();

	return 0;
}
