/obj/item/weapon/spirit_board
	name = "spirit board"
	desc = "A wooden board with letters etched into it, used in seances."
	icon = 'icons/obj/objects.dmi'
	icon_state = "spirit_board"
	density = TRUE
	var/next_use = 0
	var/planchette = "A"
	var/lastuser = null

/obj/item/weapon/spirit_board/examine()
	desc = "[initial(desc)] The planchette is sitting at \"[planchette]\"."
	..()

/obj/item/weapon/spirit_board/attack_hand(mob/user)
	if (user.a_intent == I_GRAB)
		return ..()
	else
		spirit_board_pick_letter(user)


//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/weapon/spirit_board/attack_ghost(var/mob/observer/ghost/user)
	spirit_board_pick_letter(user)
	return ..()

/obj/item/weapon/spirit_board/proc/spirit_board_pick_letter(mob/M)
	if(!spirit_board_checks(M))
		return 0
	planchette = input("Choose the letter.", "Seance!") as null|anything in list(
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
		"YES", "NO", "GOODBYE")
	if(!planchette || !Adjacent(M) || next_use > world.time)
		return	next_use = world.time + rand(30,50)
	lastuser = M.ckey
	//blind message is the same because not everyone brings night vision to seances
	var/msg = "<span class='notice'>The planchette slowly moves... and stops at the letter \"[planchette]\".</span>"
	visible_message(msg)

/obj/item/weapon/spirit_board/proc/spirit_board_checks(mob/M)
	//cooldown
	var/bonus = 0
	if(M.ckey == lastuser)
		bonus = 10 //Give some other people a chance, hog.

	if(next_use - bonus > world.time )
		return 0 //No feedback here, hiding the cooldown a little makes it harder to tell who's really picking letters.

	//lighting check
	var/light_amount = 0
	var/turf/T = get_turf(src)
	light_amount = T.get_lumcount()


	if(light_amount > 0.2)
		to_chat(M, "<span class='warning'>It's too bright here to use [src.name]!</span>")
		return 0

	//mobs in range check
	var/users_in_range = 0
	for(var/mob/living/L in orange(1,src))
		if(L.ckey && L.client)
			if((world.time - L.client.inactivity) < (world.time - 300) || L.stat != CONSCIOUS || L.restrained())//no playing with braindeads or corpses or handcuffed dudes.
				to_chat(M, "<span class='warning'>[L] doesn't seem to be paying attention...</span>")
			else
				users_in_range++

	if(users_in_range < 2)
		to_chat(M, "<span class='warning'>There aren't enough people to use the [src.name]!</span>")
		return 0

	return 1