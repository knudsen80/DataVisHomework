# Incorporate the random library
import random

# Print Title
print("Let's Play Rock Paper Scissors!")

# Specify the three options
options = ["r", "p", "s"]

# Computer Selection
computer_choice = random.choice(options)

# User Selection
user_choice = input("Make your Choice: (r)ock, (p)aper, (s)cissors? ")

# Run Conditionals
print("computer picks: " + str(computer_choice))

if (user_choice == "r" and computer_choice == "s") or (user_choice == "p" and computer_choice == "r") or (user_choice == "s" and computer_choice == "p"):
    print("you win. " + str(user_choice) + " beats " + str(computer_choice))
elif user_choice == computer_choice:
    print("it's a tie! you both picked " + str(computer_choice))
else:
    print("you lose. " + str(computer_choice) + " beats " + str(user_choice))

print("")
