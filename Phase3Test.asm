.data
     money_insert_string: .asciiz "\nPlease insert money: \n"
     prompt_menu: .asciiz "\nPlease make a selection: \n 1) $1 - Water \n 2) $2 - Snacks \n 3) $3 - Sandwich \n 4) $4 - Meals \nExit = -1\n"
 #prompts user
     cant_afford: .asciiz "\nYou can't afford this with your current balance. Please make another selection or exit \n"
     current_bal: .asciiz "\nYour current balance is: $"
     remaining_bal: .asciiz "\nRemaining balance is: $"
     incorrect_bal: .asciiz "\n Your inserted amount is invalid. Please insert a valid amount\n"
     incorrect_sel: .asciiz "\nYour selection is invalid. Please select another option\n"
     new_line: .asciiz "\n"
 ### REGISTERS BEING USED ###
 # $t1 is current balance
 # $t2 is user input
 # $t3 is used for subtracting current balance and user input
.text
insert_menu:
    # for printing money inserted
    li $v0, 4
    # $v0 is set to 4 for printing strings
    la $a0, money_insert_string # prints money_insert text
    syscall
    # Reads user input for how much money they put in
    li $v0, 5
    # loading $v0 with 5 prepares program to have user input
    syscall
    la $t1, 0($v0) # stores user input in $t1
    ble $t1,0, invalid_money_insert
    # calls display_prompt
    jal display_prompt
display_prompt:
    # Print menu options
    li $v0, 4
    # branches if user tries to insert 0 or negative money
    # $v0 is set to 4 for printing strings
    la $a0, prompt_menu
    syscall
    # prints prompt_menu
    # prints current balance string
    li $v0, 4
    la $a0, current_bal
    syscall
    # prints current balance integer
    li $v0, 1
    # $v0 is set to 1 for printing integers
    move $a0, $t1
    syscall
    # Prints a new line
    li $v0, 4
    la $a0, new_line
    syscall
    # Read user input
    li $v0, 5
    syscall
    #loading $v0 with 5 prepares program to have user input
    la $t2, 0($v0)
    # stores user input in $t2
    # branch if cases
    beq $t2,-1, exit # Branches to exit if user inputs-1
    bgt $t2, 4, incorrect_selection # Branches to incorrect selection if user prints anything greater than 4
    blt $t2,-1, incorrect_selection  # Branches if user inputs anything less than-1
    beq $t2, 0, incorrect_selection  # Branches if user inputs 0
    sub $t3, $t1, $t2  # Subtracts current balance and cost of purchase. Stores it in $t3
    blt $t3, 0, not_enough  # if $t3 is less than 0 then branches to not enough
    la $t1, ($t3)
    jal display_prompt
not_enough:
    li $v0, 4
    la $a0, cant_afford
    syscall
    jal display_prompt
incorrect_selection:
    li $v0, 4
    # loops back to display_prompt
    la $a0, incorrect_sel # sets $a0 to incorrect selection text
    syscall
    jal display_prompt
invalid_money_insert:
    li $v0, 4
    # loops back to display_prompt
    la $a0, incorrect_bal #sets $a0 to incorrect balance text
    syscall
    jal insert_menu
# Exit function
exit:
    #prints remaining balance string
    li $v0, 4
    la $a0, remaining_bal
    syscall
    #prints remaining balance integer
    li $v0, 1
    move $a0, $t1
    syscall
    #exits program
    li $v0, 10
    syscall