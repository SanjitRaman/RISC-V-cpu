import random

results = []

for i in range(100):
    operand1 = random.randrange(0, 2**32)
    operand2 = random.randrange(0, 2**32)
    print(' '.join(f'{operand1:02X}'[i:i+2] for i in range(0, 8, 2)))
    print(' '.join(f'{operand2:02X}'[i:i+2] for i in range(0, 8, 2)))
    results.append(operand1 & operand2)

print("Answers:")

for i in range(100):
    print(f'{results[i]:08X}')
