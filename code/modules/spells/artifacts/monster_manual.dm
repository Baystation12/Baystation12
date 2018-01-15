/obj/item/weapon/monster_manual
	name = "monster manual"
	desc = "A book detailing various magical creatures."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookHacking"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	var/uses = 1
	var/temp = null
	var/list/monster = list(/mob/living/simple_animal/familiar/pet/cat,
							/mob/living/simple_animal/familiar/pet/mouse,
							/mob/living/simple_animal/familiar/carcinus,
							/mob/living/simple_animal/familiar/horror,
							/mob/living/simple_animal/familiar/minor_amaros,
							/mob/living/simple_animal/familiar/pike
							)
	var/list/monster_info = list(   "It is well known that the blackest of cats make good familiars.",
									"Mice are full of mischief and magic. A simple animal, yes, but one of the wizard's finest.",
									"A mortal decendant of the original Carcinus, it is said their shells are near impenetrable and their claws as sharp as knives.",
									"The physical embodiment of flesh and decay, its made from the reanimated corpse of a murdered man.",
									"A small magical creature known for its healing powers and pacifist ways.",
									"The more carnivorous and knowledge hungry cousin of the Space Carp. Keep away from books."
									)

/obj/item/weapon/monster_manual/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/weapon/monster_manual/interact(mob/user as mob)
	var/dat
	if(temp)
		dat = "[temp]<br><a href='byond://?src=\ref[src];temp=1'>Return</a>"
	else
		dat = "<center><h3>Monster Manual</h3>You have [uses] uses left.</center>"
		for(var/i=1;i<=monster_info.len;i++)
			var/mob/M = monster[i]
			var/name = capitalize(initial(M.name))
			dat += "<BR><a href='byond://?src=\ref[src];path=\ref[monster[i]]'>[name]</a> - [monster_info[i]]</BR>"
	user << browse(dat,"window=monstermanual")
	onclose(user,"monstermanual")

/obj/item/weapon/monster_manual/OnTopic(user, href_list, state)
	if(href_list["temp"])
		temp = null
		. = TOPIC_REFRESH
	else if(href_list["path"])
		if(uses == 0)
			to_chat(user, "This book is out of uses.")
			return TOPIC_HANDLED

		var/path = locate(href_list["path"]) in monster
		if(!ispath(path, /mob/living/simple_animal/familiar))
			crash_with("Invalid mob path in [src]. Contact a coder.")
			return TOPIC_HANDLED
		var/turf/T = get_turf(src)
		if(!T)
			return TOPIC_HANDLED

		var/obj/effect/wizard_summon_circle/WSC = new(T)
		if(!SSghosttraps.RequestCandidates(/decl/ghost_trap/wizard_familiar, "A wizard is requesting a familiar.", WSC, user, src, path))
			qdel(WSC)
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)
