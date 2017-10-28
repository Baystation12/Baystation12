#include "smugglers.dmm"
#include "smugglers_areas.dm"
#include "../mining/mining_areas.dm"

/obj/effect/overmap/sector/smugglers
	name = "Abandoned smugglers den"
	desc = "This looks like abandoned small asteroid station."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
		"nav_smugglers",
		"nav_smugglers_antag"
	)

/obj/effect/shuttle_landmark/nav_asteroid_base/nav1
	name = "Abandoned asteroid base Navpoint #1"
	landmark_tag = "nav_smugglers"

/obj/effect/shuttle_landmark/nav_asteroid_base/nav2
	name = "Abandoned asteroid base Navpoint #2"
	landmark_tag = "nav_smugglers_antag"


/obj/item/weapon/paper/smug_1
	name = "Smuggler's note"
	info = "This one goes to Nyx, Tranist station 3, dock 14. Ask dr. Jensen.<BR> <b>Ask no less than 4000 thalers!</b>"

/obj/item/weapon/paper/smug_2
	name = "Smuggler's note"
	info = "That vox fuckface will be curious about what we got from that mine storage last week."

/obj/item/weapon/paper/smug_3
	name = "Smuggler's note"
	info = "If I catch any of you stupid asses smoking near canisters again, you'll end up near Tony behind that rocky wall!"

/obj/item/weapon/paper/smug_4
	name = "Smuggler's note"
	info = "<list>\[*] Special order +3000 th.\[*] Some handguns, used +800 th.\[*] Another uranium delivery  +2450 th.\[*] Two human hearts in freezer +1000 th. for each <small>(Make it 1500, shit is gross)</small>\[*] Some food and pills -340 th.</list>"

/obj/item/weapon/paper/smug_5
	name = "Smuggler's note"
	info = "Jacky, he keeps holding our shares. I'll get fucker down when we'll be back from next flight. <i>Tony</i>"

/obj/structure/closet/smuggler
	name = "Smuggler's locker"
	desc = "Rusty, greasy old locker smelling like cheap bar and smoking"
	//will_contain = list(/obj/random/ammo = 10,/obj/random/contraband = 1,/obj/random/drinkbottle = 2,/obj/random/cash = 3,/obj/random/smokes,new /datum/atom_creator/weighted( /obj/item/weapon/haircomb),new /datum/atom_creator/weighted( /obj/item/weapon/reagent_containers/syringe, 50),new /datum/atom_creator/weighted( /obj/item/weapon/reagent_containers/syringe/steroid, 10),new /datum/atom_creator/weighted( /obj/item/weapon/reagent_containers/syringe/steroid, 10),new /datum/atom_creator/weighted( list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola, /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle, /obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb)),new /datum/atom_creator/weighted( /obj/item/clothing/glasses/eyepatch, 30),new /datum/atom_creator/weighted( /obj/item/clothing/gloves/duty, 80),new /datum/atom_creator/weighted( /obj/item/clothing/mask/balaclava/tactical, 30))

/obj/random/ore_smug
	name = "random ore  for smuggling"
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
	desc = "This is smuggler's a random ammo magazine."
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
	name = "Smugglers' plastic crate with ammo"
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
	name = "Smugglers' plastic crate with weapons"
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