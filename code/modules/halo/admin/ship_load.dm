
/datum/npc_ship/hum_ert
	mapfile_links = list('maps/npc_ships/ert_ship_human.dmm')
	fore_dir = WEST
	map_bounds = list(1,29,48,5)

/datum/npc_ship/cov_ert
	mapfile_links = list('maps/npc_ships/ert_ship_covenant.dmm')
	fore_dir = WEST
	map_bounds = list(3,26,48,3)

/obj/effect/overmap/ship/npc_ship/ert_human
	name = "Human ERT Ship"
	invisibility = 60 //Ghost-tier invis.
	default_delay = 1 SECOND
	ship_datums = list(/datum/npc_ship/hum_ert)

/obj/effect/overmap/ship/npc_ship/ert_covenant
	name = "Covenant ERT Ship"
	invisibility = 60 //Ghost-tier invis.
	default_delay = 1 SECOND
	ship_datums = list(/datum/npc_ship/cov_ert)

/datum/admin_secret_item/fun_secret/spawn_load_ship
	name = "Spawn and Load Ship"

/datum/admin_secret_item/fun_secret/spawn_load_ship/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/spawn_load_ship/execute(var/mob/user)
	to_chat(user,"Ensure you are on the system map and are at the location you would like the ship spawned. before executing this command.\nThe spawned ship will contain nearly all equipment available to that faction, if you intnd to restrict spawned ERT members, ensure they are informed.")
	var/do_continue = input(user,"Continue?","Continue?","No") in list("Yes","No")
	if(do_continue == "No")
		return

	var/ship_type_selection = input(user,"What type of ship do you want to create?","Ship Type Selection","Cancel") in typesof(/datum/npc_ship) - /datum/npc_ship + list("Cancel")
	if(ship_type_selection == "Cancel")
		return
	var/datumcreated = new ship_type_selection
	var/obj/effect/overmap/ship/npc_ship/spawned = new (user.loc)

	spawned.chosen_ship_datum = datumcreated
	spawned.make_player_controlled()
	sleep(30) //Wait a few ticks.
	user.loc = locate(1,1,world.maxz)
