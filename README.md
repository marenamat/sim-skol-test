# Simple simulation of testing in schools.

Let's simulate testing in schools. Let's assume better performance of tests
than research: https://www.cdc.gov/mmwr/volumes/69/wr/mm695152a3.htm

sensitivity to be at least 90% -> 0.9 = P / (P + FN)
specificity to be at least 99.5% -> 0.995 = N / (N + FP)

There are on average 25 pupils in each class. If any of them has positive test
result, all of them are quarantined for a week.

Incidency of real positives should be around 2.5% (in current state).
There are also, let's say, around 4% absenteers for another reason.
There are about 1.5M pupils in schools.

How many classes are going to be quarantined and how many of them due to false
positives only?

