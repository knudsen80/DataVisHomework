# Number chain

cont = "y"

while cont == "y":

    user_num = int(input("How many numbers? "))

    num = user_num + 100 #Start at a higher number for printing

    for x in range(0,user_num):
        
        print(num-x)
    
    num = num-user_num

    cont = input("Would you like to continue? [y/n] ")

    while cont == "y":

        for x in range(0,user_num):
        
            print(num-x)
            #num -= 1
        
        num = num-user_num

        cont = input("Would you like to continue? [y/n] ") 

if cont =="n":
    print("Ok, no problem")
    print("")
else:
    print("Error")
    print("")
