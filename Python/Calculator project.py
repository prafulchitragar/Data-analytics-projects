# python program to create a simple calculator

# Step 1: Define functions
def add(num1,num2):
    return num1+num2

def sub(num1,num2):
    return num1-num2

def multiply(num1,num2):
    return num1*num2

def divide(num1,num2):
    return num1/num2

def average(num1,num2):
    return (num1+num2)/2

# Step 2: User input
print("Please select an operation\n" \
     "1.Addition\n" \
     "2.Subtract\n" \
     "3.Multiply\n" \
     "4.Divide\n" \
     "5.Average" )

select=int(input("Select an operation from above 1,2,3,4,5: "))

num1=int(input("Enter the first number: "))
num2=int(input("Enter the second number: "))

# Step 3: Print result

if select==1:
    print(num1, "+", num2, "=" ,add(num1,num2))

elif select==2:
    print(num1, "-", num2, "=" ,sub(num1,num2))

elif select==3:
    print(num1, "*", num2, "=" ,multiply(num1,num2))

elif select==4:
    print(num1, "/", num2, "=" ,divide(num1,num2))

elif select==5:
    print("(",num1,"+",num2,")/2", "=" , average(num1,num2))

else:
    print("Invalid option, Please select options from above")

