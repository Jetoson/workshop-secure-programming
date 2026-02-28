#include <stdio.h>

/*
 * Exercise 08 - Negative Amount (Integer Logic Flaw)
 * WORKSHOP: Secure Programming
 *
 * Audit: Read this code carefully. Can you spot the security flaw?
 *
 * A simplified banking function that processes money transfers.
 */

static int balance = 1000;   /* Starting balance */

static void show_balance(void)
{
	printf("Current balance: %d coins\n", balance);
}

static void transfer(int amount)
{
	 if (amount <= 0) {
                printf("[-] Invalid amount: must be a positive number.\n");
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
