import os

directory = '/home/sanjit/Documents/iac/Team-10-RISC-V/programs/single_instruction_tests'
data_files = []

# Find all data_mem.mem files in the directory
for root, dirs, files in os.walk(directory):
    for file in files:
        if file == 'data_mem.mem':
            data_files.append(os.path.join(root, file))

# Process each data_mem.mem file
for file in data_files:
    with open(file, 'r') as f:
        data = f.read()

    lines = data.split('\n')
    reversed_columns = []

    for line in lines:
        columns = line.split()
        reversed_columns.append(' '.join(columns[::-1]))

    reversed_data = '\n'.join(reversed_columns)

    # Overwrite existing data_mem.mem file with reversed data
    with open(file, 'w') as f:
        f.write(reversed_data)
