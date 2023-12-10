import random

results = []
numcases = 5

for i in range(numcases):
    operand1 = random.randrange(0, 2**32)
    operand2 = random.randrange(0, 2**32)
    operand1_str = ' '.join(f'{operand1:08X}'[i:i+2] for i in range(0, 8, 2))
    operand2_str = ' '.join(f'{operand2:08X}'[i:i+2] for i in range(0, 8, 2))
    print(operand1_str)
    print(operand2_str)
    results.append(operand1 ^ operand2)

print("Answers:")

for i in range(numcases):
    print(f"0x{results[i]:08X}")
