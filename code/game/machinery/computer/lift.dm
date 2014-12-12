/obj/machinery/computer3/lift
	name = "Lift Control Panel"
	desc = "Allows you to select which floor you would like to go to."
	icon = 'icons/obj/computer.dmi'
	icon_state = "airtunnel1e"
	show_keyboard = 0
	default_prog	= /datum/file/program/lift
	spawn_parts		= list(/obj/item/part/computer/lift) //NO HDD - the game is loaded on the circuitboard's OS slot

/obj/item/part/computer/lift

/datum/file/program/lift
	desc = "Program to allow movement between floors"
	//active_state = "generic"
	var/currentfloor = src.z
	switch currentfloor
		if ("1")
			floor = "Civilian Level (1)"
		if ("7")
			floor = "Command Level (2)"
		if ("8")
			floor = "Basement Level (0)"

/datum/file/program/arcade/interact()
	if(!interactable())
		return
	var/dat// = topic_link(src,"close","Close")
	dat = "<center><h4>You are currently on:<b>[floor]</b<</h4></center>"

	dat += "<br><center><h3>[temp]</h3></center>"
	dat += "<br><center>Health: [player_hp] | Magic: [player_mp] | Enemy Health: [enemy_hp]</center>"

	if (gameover)
		dat += "<center><b>[topic_link(src,"newgame","New Game")]"
	else
		dat += "<center><b>[topic_link(src,"attack","Attack")] | [topic_link(src,"heal","Heal")] | [topic_link(src,"charge","Recharge Power")]"

	dat += "</b></center>"

	popup.set_content(dat)
	popup.open()

/datum/file/program/arcade/Topic(href, list/href_list)
	if(!interactable() || ..(href,href_list))
		return
	if (!blocked && !gameover)
		if ("attack" in href_list)
			blocked = 1
			var/attackamt = rand(2,6)
			temp = "You attack for [attackamt] damage!"
			computer.updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			enemy_hp -= attackamt
			arcade_action()

		else if ("heal" in href_list)
			blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			temp = "You use [pointamt] magic to heal for [healamt] damage!"
			computer.updateUsrDialog()
			turtle++

			sleep(10)
			player_mp -= pointamt
			player_hp += healamt
			blocked = 1
			computer.updateUsrDialog()
			arcade_action()

		else if ("charge" in href_list)
			blocked = 1
			var/chargeamt = rand(4,7)
			temp = "You regain [chargeamt] points"
			player_mp += chargeamt
			if(turtle > 0)
				turtle--

			computer.updateUsrDialog()
			sleep(10)
			arcade_action()

	if ("newgame" in href_list) //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0
		computer.updateUsrDialog()


/datum/file/program/arcade/proc/arcade_action()
	if ((enemy_mp <= 0) || (enemy_hp <= 0))
		if(!gameover)
			gameover = 1
			temp = "[enemy_name] has fallen! Rejoice!"
			if(computer.toybox)
				computer.toybox.dispense()

	else if ((enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		temp = "[enemy_name] steals [stealamt] of your power!"
		player_mp -= stealamt

		if (player_mp <= 0)
			gameover = 1
			sleep(10)
			temp = "You have been drained! GAME OVER"
			feedback_inc("arcade_loss_mana_normal")

	else if ((enemy_hp <= 10) && (enemy_mp > 4))
		temp = "[enemy_name] heals for 4 health!"
		enemy_hp += 4
		enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		temp = "[enemy_name] attacks for [attackamt] damage!"
		player_hp -= attackamt

	if ((player_mp <= 0) || (player_hp <= 0))
		gameover = 1
		temp = "You have been crushed! GAME OVER"
		feedback_inc("arcade_loss_hp_normal")

	if(interactable())
		computer.updateUsrDialog()
	blocked = 0
	return