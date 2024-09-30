from random import randint

def rng(min, max):
    if min > max:
        raise ValueError("Minimum number can't be greater than maximum number.")
    return randint(min, max)

min_num = int(input("Enter the minimum number: "))
max_num = int(input("Enter the maximum number: "))

print(rng(min_num, max_num))