import subprocess

# Define password requirements
min_length = 12
max_length = 64
min_complexity = 3

# Run the password audit
output = subprocess.check_output(["sudo", "awk", "-F:", '{print $1}' "/etc/shadow"]).decode('utf-8')
for user in output.split('\n'):
    if user == '':
        continue
    password = subprocess.check_output(["sudo", "grep", user, "/etc/shadow"]).decode('utf-8').split(':')[1]
    # Check password length
    if len(password) < min_length or len(password) > max_length:
        print(f"Password for user {user} is too short or too long")
    # Check password complexity
    complexity_score = 0
    if any(char.isdigit() for char in password):
        complexity_score += 1
    if any(char.islower() for char in password):
        complexity_score += 1
    if any(char.isupper() for char in password):
        complexity_score += 1
    if any(char in '!@#$%^&*()_+-=[]{}|;:,.<>/?`~' for char in password):
        complexity_score += 1
    if complexity_score < min_complexity:
        print(f"Password for user {user} is not complex enough")
