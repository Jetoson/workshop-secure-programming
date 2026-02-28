#include <stdio.h>
#include <string.h>

/*
 * Tutorial 05 - Buffer Overflow
 * WORKSHOP: Secure Programming
 *
 * Audit: Read this code carefully. Can you spot the security flaw?
 */

void greet_user(void)
{
	char buffer[128];   /* Only 128 bytes allocated */

	printf("What is your name? ");
	fflush(stdout);

	fgets(buffer, 128, stdin);      /* UNSAFE: reads past buffer size - no bounds check! */

	printf("Hello, %s!\n", buffer);
}

int main(void)
{
	greet_user();

	return 0;
}
