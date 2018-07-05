#include "smugglers_areas.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/sector/smugglers
	name = "asteroid station"
	desc = "A small station built into an asteroid. No radio traffic detected."
	icon_state = "object"
	known = 0

	initial_generic_waypoints = list(
		"nav_smugglers",
		"nav_smugglers_antag"
	)

/datum/map_template/ruin/away_site/smugglers
	name = "Smugglers' Base"
	id = "awaysite_smugglers"
	description = "Yarr."
	suffixes = list("smugglers/smugglers.dmm")
	cost = 1

/obj/effect/shuttle_landmark/nav_asteroid_base/nav1
	name = "Abandoned Asteroid Base Navpoint #1"
	landmark_tag = "nav_smugglers"

/obj/effect/shuttle_landmark/nav_asteroid_base/nav2
	name = "Abandoned Asteroid Base Navpoint #2"
	landmark_tag = "nav_smugglers_antag"
	autoset = 1

/obj/item/weapon/paper/smug_1
	name = "suspicios note"
	info = "This one goes to Nyx, Tranist station 3, dock 14. Ask Dr. Jensen.<BR> <b>Ask no less than 4000 thalers!</b>"

/obj/item/weapon/paper/smug_2
	name = "suspicious note"
	info = "That vox fuckface will be curious about what we got from that mine storage last week."

/obj/item/weapon/paper/smug_3
	name = "suspicious note"
	info = "If I catch any of you stupid asses smoking near canisters again, you'll end up near Tony behind that rocky wall!"

/obj/item/weapon/paper/smug_4
	name = "suspicious note"
	info = "<list>\[*] Special order +3000 th.\[*] Some handguns, used +800 th.\[*] Another uranium delivery  +2450 th.\[*] Two human hearts in freezer +1000 th. for each <small>(Make it 1500, shit is gross)</small>\[*] Some food and pills -340 th.</list>"

/obj/item/weapon/paper/smug_5
	name = "suspicious note"
	info = "Jacky, he keeps holding our shares. I'll get fucker down when we'll be back from next flight. <i>Tony</i>"

/obj/structure/closet/smuggler
	name = "suspicious locker"
	desc = "Rusty, greasy old locker, smelling of cigarettes and cheap alcohol."

/obj/structure/closet/smuggler/WillContain()
	return list(
		/obj/random/ammo,
		/obj/random/contraband,
		/obj/random/contraband,
		/obj/random/drinkbottle,
		/obj/random/drinkbottle,
		/obj/random/cash,
		/obj/random/cash,
		/obj/random/cash,
		/obj/random/smokes,
		new /datum/atom_creator/simple(/obj/item/weapon/reagent_containers/syringe, 50),
		new /datum/atom_creator/simple(/obj/item/weapon/reagent_containers/syringe/steroid, 10),
		new /datum/atom_creator/simple(/obj/item/weapon/reagent_containers/syringe/steroid, 10),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola, /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle, /obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb)),
		new /datum/atom_creator/simple(/obj/item/clothing/glasses/eyepatch, 30),
		new /datum/atom_creator/simple(/obj/item/clothing/gloves/duty, 80),
		new /datum/atom_creator/simple(/obj/item/clothing/mask/balaclava/tactical, 30))

/obj/random/ore
	name = "random ore"
	desc = "This is a random ore."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "horribletie"

/obj/random/ore_smug/spawn_choices()
	return list(
		/obj/item/weapon/ore/uranium,
		/obj/item/weapon/ore/gold,
		/obj/item/weapon/ore/silver,
		/obj/item/weapon/ore/slag,
		/obj/item/weapon/ore/phoron)

/obj/random/ammo_magazine_smug
	name = "Random Ammo Magazine"
	desc = "This is smuggler's random ammo magazine."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo_magazine_smug/spawn_choices()
	return list(
		/obj/item/ammo_magazine/a10mm,
		/obj/item/ammo_magazine/a357,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c556,
		/obj/item/ammo_magazine/a762)

/obj/structure/closet/crate/plastic_smug_ammo
	name = "dirty plastic crate"
	desc = "Dirty and scrtached plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"

/obj/structure/closet/crate/plastic_smug_ammo/WillContain()
	return list(
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug,
		/obj/random/ammo_magazine_smug)

/obj/structure/closet/crate/plastic_smug_weapons
	name = "dirty plastic crate"
	desc = "Dirty and scrtached plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"

/obj/structure/closet/crate/plastic_smug_weapons/WillContain()
	return list(
		/obj/random/handgun,
		/obj/random/handgun,
		/obj/random/handgun,
		/obj/random/projectile,
		/obj/random/projectile)
