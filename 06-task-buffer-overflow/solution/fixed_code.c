#include <stdio.h>
#include <string.h>

/*
 * Exercise 06 - Buffer Overflow: FIXED VERSION
 *
 * Fix: Replace gets() with fgets(), which enforces a maximum read length.
 *      The second argument limits input to sizeof(buffer)-1 bytes,
 *      ensuring the buffer can never be overflowed regardless of input size.
 */

static void greet_user(void)
{
	char buffer[64];

	printf("What is your name? ");
	fflush(stdout);

	/* SECURE: fgets(buf, n, stream) reads at most n-1 bytes */
	fgets(buffer, sizeof(buffer), stdin);

	/* fgets keeps the '\n' — strip it for a cleaner greeting */
	buffer[strcspn(buffer, "\n")] = '\0';

	printf("Hello, %s!\n", buffer);
}

int main(void)
{
	greet_user();

	return 0;
}
