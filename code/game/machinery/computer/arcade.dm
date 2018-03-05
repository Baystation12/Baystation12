/obj/machinery/computer/arcade/
	name = "random arcade"
	desc = "A random arcade machine."
	icon_state = "arcade"
	icon_keyboard = null
	icon_screen = "invaders"
	var/list/prizes = list(	/obj/item/weapon/storage/box/snappops										= 2,
							/obj/item/toy/blink															= 2,
							/obj/item/clothing/under/syndicate/tacticool								= 2,
							/obj/item/toy/sword															= 2,
							/obj/item/weapon/gun/projectile/revolver/capgun								= 2,
							/obj/item/toy/crossbow														= 2,
							/obj/item/clothing/suit/syndicatefake										= 2,
							/obj/item/weapon/storage/fancy/crayons										= 2,
							/obj/item/toy/spinningtoy													= 2,
							/obj/item/toy/prize/ripley													= 1,
							/obj/item/toy/prize/fireripley												= 1,
							/obj/item/toy/prize/deathripley												= 1,
							/obj/item/toy/prize/gygax													= 1,
							/obj/item/toy/prize/durand													= 1,
							/obj/item/toy/prize/honk													= 1,
							/obj/item/toy/prize/marauder												= 1,
							/obj/item/toy/prize/seraph													= 1,
							/obj/item/toy/prize/mauler													= 1,
							/obj/item/toy/prize/odysseus												= 1,
							/obj/item/toy/prize/phazon													= 1,
							/obj/item/weapon/reagent_containers/spray/waterflower						= 1,
							/obj/random/action_figure													= 1,
							/obj/random/plushie															= 1,
							/obj/item/toy/cultsword														= 1
							)

/obj/machinery/computer/arcade/Initialize()
	. = ..()
	// If it's a generic arcade machine, pick a random arcade
	// circuit board for it and make the new machine
	if(!circuit)
		var/choice = pick(typesof(/obj/item/weapon/circuitboard/arcade) - /obj/item/weapon/circuitboard/arcade)
		var/obj/item/weapon/circuitboard/CB = new choice()
		new CB.build_path(loc, CB)
		return INITIALIZE_HINT_QDEL

/obj/machinery/computer/arcade/proc/prizevend()
	if(!contents.len)
		var/prizeselect = pickweight(prizes)
		new prizeselect(src.loc)

		if(istype(prizeselect, /obj/item/clothing/suit/syndicatefake)) //Helmet is part of the suit
			new	/obj/item/clothing/head/syndicatefake(src.loc)

	else
		var/atom/movable/prize = pick(contents)
		prize.forceMove(src.loc)

/obj/machinery/computer/arcade/attack_ai(mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/computer/arcade/emp_act(severity)
	if(stat & (NOPOWER|BROKEN))
		..(severity)
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pickweight(prizes)
		new empprize(src.loc)

	..(severity)

///////////////////
//  BATTLE HERE  //
///////////////////

/obj/machinery/computer/arcade/battle
	name = "arcade machine"
	desc = "Does not support Pinball."
	icon_state = "arcade"
	circuit = /obj/item/weapon/circuitboard/arcade/battle
	var/enemy_name = "Space Villian"
	var/temp = "Winners don't use space drugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/turtle = 0

/obj/machinery/computer/arcade/battle/Initialize()
	. = ..()
	SetupGame()

/obj/machinery/computer/arcade/battle/proc/SetupGame()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ", "Pwn ", "Own ", "Ban ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "slime", "Griefer", "ERPer", "Lizard Man", "Unicorn", "Bloopers")

	src.enemy_name = replacetext((name_part1 + name_part2), "the ", "")
	src.SetName((name_action + name_part1 + name_part2))


/obj/machinery/computer/arcade/battle/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	dat += "<center><h4>[src.enemy_name]</h4></center>"

	dat += "<br><center><h3>[src.temp]</h3></center>"
	dat += "<br><center>Health: [src.player_hp] | Magic: [src.player_mp] | Enemy Health: [src.enemy_hp]</center>"

	dat += "<center><b>"
	if (src.gameover)
		dat += "<a href='byond://?src=\ref[src];newgame=1'>New Game</a>"
	else
		dat += "<a href='byond://?src=\ref[src];attack=1'>Attack</a> | "
		dat += "<a href='byond://?src=\ref[src];heal=1'>Heal</a> | "
		dat += "<a href='byond://?src=\ref[src];charge=1'>Recharge Power</a>"

	dat += "</b></center>"

	user << browse(dat, "window=arcade")
	onclose(user, "arcade")
	return

/obj/machinery/computer/arcade/battle/CanUseTopic(var/mob/user, var/datum/topic_state/state, var/href_list)
	if((blocked || gameover) && (href_list["attack"] || href_list["heal"] || href_list["charge"]))
		return min(..(), STATUS_UPDATE)
	return ..()

/obj/machinery/computer/arcade/battle/OnTopic(user, href_list)
	set waitfor = 0

	if (href_list["close"])
		close_browser(user, "window=arcade")
		return TOPIC_HANDLED

	if (href_list["attack"])
		src.blocked = 1
		var/attackamt = rand(2,6)
		src.temp = "You attack for [attackamt] damage!"
		if(turtle > 0)
			turtle--
		src.enemy_hp -= attackamt

		. = TOPIC_REFRESH
		sleep(10)
		src.arcade_action(user)

	else if (href_list["heal"])
		src.blocked = 1
		var/pointamt = rand(1,3)
		var/healamt = rand(6,8)
		src.temp = "You use [pointamt] magic to heal for [healamt] damage!"
		turtle++

		src.player_mp -= pointamt
		src.player_hp += healamt
		src.blocked = 1

		. = TOPIC_REFRESH
		sleep(10)
		src.arcade_action(user)

	else if (href_list["charge"])
		src.blocked = 1
		var/chargeamt = rand(4,7)
		src.temp = "You regain [chargeamt] points"
		src.player_mp += chargeamt
		if(turtle > 0)
			turtle--

		. = TOPIC_REFRESH
		sleep(10)
		src.arcade_action(user)

	else if (href_list["newgame"]) //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0
		if(emagged)
			emagged = 0
			SetupGame()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/computer/arcade/battle/proc/arcade_action(var/user)
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		if(!gameover)
			src.gameover = 1
			src.temp = "[src.enemy_name] has fallen! Rejoice!"

			if(emagged)
				feedback_inc("arcade_win_emagged")
				new /obj/effect/spawner/newbomb/timer/syndicate(src.loc)
				new /obj/item/clothing/head/collectable/petehat(src.loc)
				log_and_message_admins("has outbombed Cuban Pete and been awarded a bomb.")
				SetupGame()
				emagged = 0
			else
				feedback_inc("arcade_win_normal")
				src.prizevend()

	else if (emagged && (turtle >= 4))
		var/boomamt = rand(5,10)
		src.temp = "[src.enemy_name] throws a bomb, exploding you for [boomamt] damage!"
		src.player_hp -= boomamt

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "[src.enemy_name] steals [stealamt] of your power!"
		src.player_mp -= stealamt
		attack_hand(user)

		if (src.player_mp <= 0)
			src.gameover = 1
			sleep(10)
			src.temp = "You have been drained! GAME OVER"
			if(emagged)
				feedback_inc("arcade_loss_mana_emagged")
				explode()
			else
				feedback_inc("arcade_loss_mana_normal")

	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "[src.enemy_name] heals for 4 health!"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "[src.enemy_name] attacks for [attackamt] damage!"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.gameover = 1
		src.temp = "You have been crushed! GAME OVER"
		if(emagged)
			feedback_inc("arcade_loss_hp_emagged")
			explode()
		else
			feedback_inc("arcade_loss_hp_normal")

	src.blocked = 0

/obj/machinery/computer/arcade/proc/explode()
	explosion(loc, 0, 1, 2, 3)
	qdel(src)

/obj/machinery/computer/arcade/battle/emag_act(var/charges, var/mob/user)
	if(!emagged)
		temp = "If you die in the game, you die for real!"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		blocked = 0
		emagged = 1

		enemy_name = "Cuban Pete"
		name = "Outbomb Cuban Pete"

		attack_hand(user)
		return 1