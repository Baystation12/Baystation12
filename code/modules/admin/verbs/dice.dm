/client/proc/roll_dices()
	set category = "Fun"
	set name = "Roll Dice(in developing!)"
	if(!check_rights(R_FUN))	return


	var/dice = input("Select dice. For example: 1d6, 2d6, 5d2, 1d16, 3d4+5") as text
	/*Необходима проверка dice на совпадение с маской, byond это вообще поддерживает?
	  Настройка цвета сообщений ниже не работает, надо тоже поправить. */

	dice = "2d6"//просто подстраховка от любопытных, потом убрать

	if(alert("Do you want to inform the world about your game?",,"Yes", "No") == "Yes")
		world << "<h2 style='text-color:#A50400'>The dice have been rolled by Gods!</h2>"



	var/result = roll(dice)

	if(alert("Do you want to inform the world about the result?",,"Yes", "No") == "Yes")
		world << "<h2 style='text-color:#A50400\'>Gods rolled [dice], result is [result]</h2>"

	message_admins("[key_name_admin(src)] rolled dice [dice], result is [result]", 1)