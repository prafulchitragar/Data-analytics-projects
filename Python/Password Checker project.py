import re 

# password strength checks:
# min 8 chars, digit, uppercase, lowercase, special chars

def password_strength(password):
    if len(password) <8:
        return "Weak: password must contain atleast 8 characters"
    
    if not any(char.isdigit() for char in password):
        return "Weak: Password must contain atleast an digit"
    
    if not any(char.isupper() for char in password):
        return "Weak:Password must contain atleast an uppercase letter"
    
    if not any(char.islower() for char in password):
        return "Weak:Password must contain atleast an lowercase letter"
    
    if not re.search(r'[!@#$%^&*()_{}:;<>,.?/]', password):
        return "Medium:Password must contain a special character"
    
    return "Strong: You're password is safe and secure."

def password_checker():
    print("Welcome to password strength checker")

    while True:
        password =input("Enter your password ( or type 'exit' to quit):")

        if password.lower()=='exit':
            print("Thank you for using the tool")
            break

        result=password_strength(password)
        print(result)


print(password_checker())


