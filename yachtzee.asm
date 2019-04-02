.constant TERM 0x4000
.constant CR 0xD
.constant LF 0xA
.constant KEYB 0x4002

.variable seed
.variable beef
.variable counts[6]
.variable logic[6]

.address 0x2000

!setup
	MOVI r1 = 222 		#Just a random chosen seed number from me
	STOR [seed] = r1 	#Loading in starting seed
	MOVI r1 = 0xdeadbeaf	#The infamous deadbeaf
	STOR [beef] = r1	#Storing the deadbeaf, yum

	MOVI r41 = CR
	MOVI r42 = LF
	MOVI r30 = !press_enter_string
	NOP #Not sure why the NOP is needed, remove if not

!main

!load_prompt_string
	MOVI r30 = !press_enter_string
!prompt_for_roll	
	LOAD r25 = [r30]
	BRAE [!prompt_printed : F], r25 == r0
	STOR [TERM] = r25
	ADD  r30 = r30 + 1
	BRA [!prompt_for_roll]

!prompt_printed
!look_for_keyboard_enter
	LOAD r43 = [KEYB] #Loads in character from keyboard
	BRAE [!loop_for_5], r43==r42
	NOP	
	BRA  [!look_for_keyboard_enter]

!loop_for_5
	MOVI r44 = 5 	#Loop to execute 5 times for numbers
	
!generate
	BRAE [!loop_5_done], r44==r0


	add r100 = PC + 2
	bra [!rand]
	AND r101 = r101 & 0x7FFF
	MOD r101 = r101 % 6
	ADD r101 = r101+'1'
	STOR [r44 + counts] = r101
	LOAD r102 = [r44 + counts]
#	STOR [TERM] = r102
#	MOVI r1 = 0x9		#prints tab
#	STOR [TERM] = r1
	STOR [r44 + counts] = r101 	
	DEC r44
	BRA [!generate]

!loop_5_done
#	STOR [TERM] = r41
#	STOR [TERM] = r42
#	STOR [TERM] = r41
#	STOR [TERM] = r42

!print_dice
	MOVI r30 = !dice_top_string
!top_print_loop1
	LOAD r25 = [r30]
	STOR [TERM] = r25
	ADD  r30 = r30 + 1
	BRANE  [!top_print_loop1], r25 != r0

	STOR [TERM] = r41
	STOR [TERM] = r42	
	MOVI r30 = !dice_top_bevel

!top_print_loop2
	LOAD r25 = [r30]
	STOR [TERM] = r25
	ADD  r30 = r30 + 1
	BRANE [!top_print_loop2], r25 != r0

	STOR [TERM] = r41
	STOR [TERM] = r42
	MOVI r30 = !dice_top_corners

!top_print_loop3
	LOAD r25 = [r30]
	STOR [TERM] = r25
	ADD r30 = r30 + 1
	BRANE [!top_print_loop3], r25 != r0
!print_faces
	STOR [TERM] = r41
	STOR [TERM] = r42
	ADD  r43 = r41 + 19
	STOR [TERM] = r43

	MOVI r30 = !pips

	MOVI  r1 = 0 #check for 1
	MOVI  r2 = 1 #check for 2
	MOVI  r3 = 2 #check for 3
	MOVI  r4 = 3 #check for 4
	MOVI  r5 = 4 #check for 5
	MOVI  r6 = 5 #check for 6
	MOVI  r9 = 5	 #Loop iterator
	MOVI  r10 = 5    #Faces to print
	MOVI  r11 = 3     #Number of layer iteretor
	MOVI  r12 = 5  #Index of counts
   	 #Number of characters per string
!tops
!value_check_tops
	LOAD r7 = [r10 + counts] #dice value
	SUB r7 = r7 - 49	
	BRAE [!row_one_1], r7==r1
	BRAE [!row_one_2], r7==r2
	BRAE [!row_one_3], r7==r3
	BRAE [!row_one_4], r7==r4
	BRAE [!row_one_5], r7==r5
	BRAE [!row_one_6], r7==r6
	
!row_one_1
	MOVI r30 = !one_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]
!row_one_2
	MOVI r30 = !two_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]
!row_one_3
	MOVI r30 = !three_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]
!row_one_4
	MOVI r30 = !four_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]
!row_one_5
	MOVI r30 = !five_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]
!row_one_6
	MOVI r30 = !six_top
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_top]

!face_row_done_top
	DEC r12
	STOR [TERM] = r43
	BRANE [!value_check_tops], r12 != r0
	STOR [TERM] = r41
	STOR [TERM] = r42
	STOR [TERM] = r43
	
!middles
	MOVI r10 = 5
	MOVI r12 = 5

!check_value_middles
	LOAD r7 = [r10 + counts]	
	SUB  r7 = r7 - 49
	
	BRAE [!row_two_1], r7==r1
	BRAE [!row_two_2], r7==r2
	BRAE [!row_two_3], r7==r3
	BRAE [!row_two_4], r7==r4
	BRAE [!row_two_5], r7==r5
	BRAE [!row_two_6], r7==r6

!row_two_1
	MOVI r30 = !one_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]
!row_two_2
	MOVI r30 = !two_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]
!row_two_3
	MOVI r30 = !three_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]
!row_two_4
	MOVI r30 = !four_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]
!row_two_5
	MOVI r30 = !five_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]
!row_two_6
	MOVI r30 = !six_mid
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_mid]

!face_row_done_mid
	DEC r12
	STOR [TERM] = r43
	BRANE [!check_value_middles], r12 != r0
	STOR [TERM] = r41
	STOR [TERM] = r42
	STOR [TERM] = r43

!bottoms
	MOVI r10 = 5
	MOVI r12 = 5
!check_value_bottoms
	LOAD r7 = [r10 + counts]	
	SUB  r7 = r7 - 49
	
	BRAE [!row_three_1], r7==r1
	BRAE [!row_three_2], r7==r2
	BRAE [!row_three_3], r7==r3
	BRAE [!row_three_4], r7==r4
	BRAE [!row_three_5], r7==r5
	BRAE [!row_three_6], r7==r6

!row_three_1
	MOVI r30 = !one_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]
!row_three_2
	MOVI r30 = !two_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]
!row_three_3
	MOVI r30 = !three_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]
!row_three_4
	MOVI r30 = !four_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]
!row_three_5
	MOVI r30 = !five_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]
!row_three_6
	MOVI r30 = !six_bot
	ADD r100 = PC + 2
	BRA [!print_row]
	DEC r10
	BRA [!face_row_done_bot]

!face_row_done_bot
	DEC r12
	STOR [TERM] = r43
	BRANE [!check_value_bottoms], r12 != r0
	STOR [TERM] = r41
	STOR [TERM] = r42

!print_bottoms
	MOVI r30 = !dice_bottom_corners
	ADD r100 = PC + 2
	BRA [!print_row]

	#BRA [!load_prompt_string]
	
	STOR [TERM] = r41
	STOR [TERM] = r42

!check_hands
	MOVI r9 = 5
!zero_logic
	STOR [r9 + logic] = r0
	DEC r9
	BRANE [!zero_logic], r9 != r0

	MOVI r9 = 5
!logic_full
	MOVI r1 = 1
	MOVI r2 = 2
	MOVI r3 = 3
	MOVI r4 = 4
	MOVI r5 = 5
	MOVI r6 = 6

	MOVI r51 = 0
	MOVI r52 = 0
	MOVI r53 = 0
	MOVI r54 = 0
	MOVI r55 = 0
	MOVI r56 = 0

	MOVI r9 = 5 #Loop iterator
!fill_logic
	LOAD r7 = [r9 + counts]
	SUB  r7 = r7 - 49 #From ascii to numeric value
	
	BRAE [!add_one], r7==r1
	BRAE [!add_two], r7==r2
	BRAE [!add_three], r7==r3
	BRAE [!add_four], r7==r4
	BRAE [!add_five], r7==r5
	BRAE [!add_six], r7==r6

!added_to_logic
	DEC r9
	BRANE [!fill_logic], r9 != r0
	BRA [!determine_hand]

!add_one
	INC r51
	BRA [!added_to_logic]
!add_two
	INC r52
	BRA [!added_to_logic]
!add_three
	INC r53
	BRA [!added_to_logic]
!add_four
	INC r54
	BRA [!added_to_logic]
!add_five
	INC r55
	BRA [!added_to_logic]
!add_six
	INC r56
	BRA [!added_to_logic]

!determine_hand

!check_yachtzee_four_kind
	BRAE [!YACHTZEE], r51==r5
	BRAE [!YACHTZEE], r52==r5
	BRAE [!YACHTZEE], r53==r5
	BRAE [!YACHTZEE], r54==r5
	BRAE [!YACHTZEE], r55==r5
	BRAE [!YACHTZEE], r56==r5

	BRAE [!four_of_a_kind], r51==r4
	BRAE [!four_of_a_kind], r52==r4	
	BRAE [!four_of_a_kind], r53==r4
	BRAE [!four_of_a_kind], r54==r4
	BRAE [!four_of_a_kind], r55==r4
	BRAE [!four_of_a_kind], r56==r4


	MOVI r12 = 0 #highest counts
!find_highest
	BRAG [!highest1], r51 > r12
	BRAG [!highest2], r52 > r12
	BRAG [!highest3], r53 > r12
	BRAG [!highest4], r54 > r12
	BRAG [!highest5], r55 > r12
	BRAG [!highest6], r56 > r12
	BRA [!check_more]	

!highest1
	MOVR r12 = r51
	BRA [!find_highest]
!highest2
	MOVR r12 = r52
	BRA [!find_highest]
!highest3
	MOVR r12 = r53
	BRA [!find_highest]
!highest4
	MOVR r12 = r54
	BRA [!find_highest]
!highest5
	MOVR r12 = r55
	BRA [!find_highest]
!highest6
	MOVR r12 = r56
	BRA [!find_highest]

!check_more
	BRAE [!check_full_house], r51 == r3
	BRAE [!check_full_house], r52 == r3
	BRAE [!check_full_house], r53 == r3
	BRAE [!check_full_house], r54 == r3
	BRAE [!check_full_house], r55 == r3
	BRAE [!check_full_house], r56 == r3
	

!check_large_straight_15
	BRAE [!straight15_further], r56==r0	

	BRA [!check_large_straight_26]
!straight15_further

#Because MiniAT called a 6 1 2 3 5 a large straight...

	BRAE [!check_large_straight_26], r51==r0
	BRAE [!check_large_straight_26], r52==r0
	BRAE [!check_large_straight_26], r53==r0
	BRAE [!check_large_straight_26], r54==r0
	BRAE [!check_large_straight_26], r55==r0
	BRAE [!straight15], r12==r1


!check_large_straight_26
	BRAE [!straight26_further], r51==r0	

	BRA [!check_small_straight_14]
!straight26_further
#why MiniAT
	BRAE [!check_small_straight_14], r52==r0
	BRAE [!check_small_straight_14], r53==r0
	BRAE [!check_small_straight_14], r54==r0
	BRAE [!check_small_straight_14], r55==r0
	BRAE [!check_small_straight_14], r56==r0
	BRAE [!straight26], r12==r1

!check_small_straight_14
	BRAE [!straight_14_further], r56==r0
	BRA [!check_small_straight_25]
!straight_14_further
	BRAE [!check_small_straight_25], r51==r0
	BRAE [!check_small_straight_25], r52==r0
	BRAE [!check_small_straight_25], r53==r0
	BRAE [!check_small_straight_25], r54==r0
	BRAE [!small_straight], r55==r0

!check_small_straight_25
	BRAE [!straight_25_further], r56==r0
	BRA [!check_small_straight_36]
!straight_25_further
	BRAE [!check_small_straight_36], r52==r0
	BRAE [!check_small_straight_36], r53==r0
	BRAE [!check_small_straight_36], r54==r0
	BRAE [!check_small_straight_36], r55==r0
	BRAE [!small_straight], r51==r0

!check_small_straight_36
	BRAE [!straight_36_further], r52==r0
	BRA [!nothing_of_interest]
!straight_36_further
	BRAE [!nothing_of_interest], r53==r0
	BRAE [!nothing_of_interest], r54==r0
	BRAE [!nothing_of_interest], r55==r0
	BRAE [!nothing_of_interest], r56==r0
	BRAE [!small_straight], r51==r0
	BRA [!nothing_of_interest]



!check_full_house
	BRAE [!full_house], r51==r2
	BRAE [!full_house], r52==r2
	BRAE [!full_house], r53==r2
	BRAE [!full_house], r54==r2
	BRAE [!full_house], r55==r2
	BRAE [!full_house], r56==r2


	BRA [!three_of_a_kind]



!YACHTZEE
	MOVI r30 = !yachtzee_string
	ADD r100 = PC + 2
	BRA [!print_hand]
	BRA [!hand_printed]

!four_of_a_kind
	MOVI r30 = !four_of_a_kind_string
	ADD r100 = PC + 2
	BRA [!print_hand]
	BRA [!hand_printed]

!full_house
	MOVI r30 = !full_house_string
	BRA [!print_hand]

!three_of_a_kind
	MOVI r30 = !three_of_a_kind_string
	BRA [!print_hand]

!straight15
!straight26
!large_straight
	MOVI r30 = !large_straight_string
	BRA [!print_hand]


!small_straight
	MOVI r30 = !small_straight_string
	BRA [!print_hand]

!nothing_of_interest
	MOVI r30 = !nothing_of_interest_string

!print_hand
	LOAD r25 = [r30]
	STOR [TERM] = r25
	ADD r30 = r30 + 1
	BRANE [!print_hand], r25 != r0

!hand_printed
	STOR[TERM] = r41
	STOR[TERM] = r42
	STOR[TERM] = r41
	STOR[TERM] = r42
	BRA [!load_prompt_string]

!print_row
	LOAD r25 = [r30]
	STOR [TERM] = r25
	ADD r30 = r30 + 1
	BRANE [!print_row], r25 != r0
	BRA [r100]

###############################################################################
###########################Functions and Strings###############################
###############################################################################

!rand
	LOAD r1 = [seed]
	LOAD r2 = [beef]
	SHL  r3 = r1<<7
	SHR  r1 = r1>>25
	ADD  r1 = r1+r2 #beef
	EXOR r1 = r3 ^ r1
	STOR [seed] = r1
	SHL  r4 = r2<<7
	SHR  r3 = r2>>25
	###########################EXOR r2 = r4^(r3 + 0xdeadbeaf)
	ADD  r3 = r3+0xdeadbeaf
	EXOR r2 = r4 ^ r3
	STOR [beef] = r2
	MOVR r101 = r1
	bra [r100]

!press_enter_string
	"Press the Enter key to roll the dice"
!dice_top_string
	 "   ______     ______     ______     ______     ______ "
!dice_top_bevel
	"  /     /|   /     /|   /     /|   /     /|   /     /|"
!dice_top_corners
	" +-----+ |  +-----+ |  +-----+ |  +-----+ |  +-----+ |"

!pips
!one_top
	"|     | | "
!one_mid
	"|  @  | | "
!one_bot
	"|     |/  "
!two_top
	"|   @ | | "
!two_mid
	"|     | | "
!two_bot
	"| @   |/  "
!three_top
	"| @   | | "
!three_mid
	"|  @  | | "
!three_bot
	"|   @ |/  "
!four_top
	"| @ @ | | "
!four_mid
	"|     | | "
!four_bot
	"| @ @ |/  "
!five_top
	"| @ @ | | "
!five_mid
	"|  @  | | "
!five_bot
	"| @ @ |/  "
!six_top
	"| @ @ | | "
!six_mid
	"| @ @ | | "
!six_bot
	"| @ @ |/  "

!dice_bottom_corners
	" +-----+    +-----+    +-----+    +-----+    +-----+  "

!yachtzee_string
	"YACHTZEE!!!"
!large_straight_string
	"Large straight"
!small_straight_string
	"Small straight"
!full_house_string
	"Full House"
!four_of_a_kind_string
	"Four of a kind"
!three_of_a_kind_string
	"Three of a kind"
!nothing_of_interest_string
	"Nothing of interest"


!print_dice_concept
" "<<<
    ______     ______     ______     ______    ______ 
   /     /|   /     /|   /     /|   /     /|  /     /|
  +-----+ |  +-----+ |  +-----+ |  +-----+ | +-----+ |
  | @   | |  |     | |  |   @ | |  | @ @ | | | @ @ | |
  |  @  | |  |  @  | |  |     | |  |     | | |  @  | |
  |   @ |/   |     |/   | @   |/   | @ @ |/  | @ @ |/ 
  +-----+    +-----+    +-----+    +-----+   +-----+  
>>>                                                      
!dice_done

!test
	MOVI r9 = 6
	MOVI r1 = -6
!test2
	LOAD r8 = [r9 + logic]
	ADD r8 = r8 + 48
	STOR [TERM] = r8
	STOR [TERM] = r43
	DEC r9
	BRAE [!inf], r9==r1
	BRA [!test2]
!inf
	BRA [!load_prompt_string]


