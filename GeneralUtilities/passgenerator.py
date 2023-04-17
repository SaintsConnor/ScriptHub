import random
import string

def generate_password(length=8, complexity=1):
    # Define character sets based on complexity level
    if complexity == 1:
        chars = string.ascii_letters
    elif complexity == 2:
        chars = string.ascii_letters + string.digits
    elif complexity == 3:
        chars = string.ascii_letters + string.digits + string.punctuation
    elif complexity == 4:
        chars = string.ascii_uppercase + string.ascii_lowercase + string.digits + string.punctuation

    # Generate password
    password = ''.join(random.choice(chars) for i in range(length))
    return password

# Prompt user for password length and complexity level
length = int(input("Enter password length: "))
complexity = int(input("Enter password complexity level (1-4): "))

# Generate password and print to console
password = generate_password(length, complexity)
print("Your password is: " + password)
