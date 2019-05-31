
/decl/hierarchy/outfit/spartan_two/red_team
	name = "Red Team Spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/red
	head = /obj/item/clothing/head/helmet/spartan/red

/decl/hierarchy/outfit/spartan_two/blue_team
	name = "Blue Team Spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/blue
	head = /obj/item/clothing/head/helmet/spartan/blue

/decl/hierarchy/outfit/sangheili/ultra/slayer
	name = "Slayer Sangheili"
	suit = /obj/item/clothing/suit/armor/special/combatharness/ultra/slayer

/obj/item/clothing/suit/armor/special/combatharness/ultra/slayer
	var/list/available_abilities = list(\
		"Hologram Decoy Emitter" = /datum/armourspecials/holo_decoy,\
		"Personal Cloaking Device" = /datum/armourspecials/cloaking/limited,\
		"Personal Regeneration Field" = /datum/armourspecials/regeneration,\
		"Overshield Emitter" = /datum/armourspecials/overshield,\
		"Upper Body Strength Enhancements" = /datum/armourspecials/superstrength,\
		"Leg Speed and Agility Enhancements" = /datum/armourspecials/superspeed\
		)

/obj/item/clothing/suit/armor/special/combatharness/ultra/slayer/equipped(var/mob/user, var/slot)
	..()
	spawn(0)
		if(user && user.client && specials.len <= 3 && available_abilities.len)
			var/ability_type_string = input(user, "Choose the armour ability of your Sangheili combat harness","Sangheili Armour Ability") in available_abilities
			var/ability_type = available_abilities[ability_type_string]
			specials.Add(new ability_type(src))
