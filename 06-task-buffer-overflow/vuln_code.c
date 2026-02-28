#include <stdio.h>
#include <string.h>

/*
 * Exercise 06 - Buffer Overflow
 * WORKSHOP: Secure Programming
 *
 * Audit: Read this code carefully. Can you spot the security flaw?
 */

void greet_user(void)
{
	char buffer[64];   /* Only 64 bytes allocated */

	printf("What is your name? ");
	fflush(stdout);

	fgets(buffer, sizeof(buffer), stdin);

	buffer[strcspn(buffer, "\n")] = '\0';
	printf("Hello, %s!\n", buffer);
}

int main(void)
{
	greet_user();

	return 0;
}
