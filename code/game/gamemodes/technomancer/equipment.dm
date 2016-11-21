/datum/technomancer/equipment/default_core
	name = "Manipulation Core"
	desc = "The default core that you most likely already have.  This is here in-case you change your mind after buying \
	another core, don't forget to refund the old core.  This has a capacity of 10,000 units of energy, and recharges at a \
	rate of 50 units.  It also reduces incoming instability from functions by 20%."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core

/datum/technomancer/equipment/rapid_core
	name = "Rapid Core"
	desc = "A core optimized for passive regeneration, however at the cost of capacity.  Has a capacity of 7,000 units of energy, and \
	recharges at a rate of 70 units.  Complex gravatics and force manipulation allows the wearer to also run slightly faster, and \
	reduces incoming instability from functions by 10%."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core/rapid

/datum/technomancer/equipment/bulky_core
	name = "Bulky Core"
	desc = "This core has very large capacitors, however it also has a subpar fractal reactor.  The user is recommended to \
	purchase one or more energy-generating Functions as well if using this core.  Has a capacity of 20,000 units of energy, \
	and recharges at a rate of 25 units.  The intense weight of the core unfortunately can cause the wear to move slightly slower, \
	and the closeness of the capacitors causes a slight increase in incoming instability by 10%."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core/bulky

/datum/technomancer/equipment/unstable
	name = "Unstable Core"
	desc = "This core feeds off unstable energies around the user in addition to a fractal reactor.  This means that it performs \
	better as the user has more instability, which could prove dangerous to the inexperienced or unprepared.  Has a capacity of 13,000 \
	units of energy, and recharges at a rate of 35 units at no instability, and approximately 110 units when within the \
	'yellow zone' of instability.  Incoming instability is also amplified by 30%, due to the nature of this core."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core/unstable

/datum/technomancer/equipment/recycling
	name = "Recycling Core"
	desc = "This core is optimized for energy efficency, being able to sometimes recover energy that would have been lost with other \
	cores.  The focus on efficency also makes instability less of an issue, as incoming instability from functions are reduced by \
	40%.  The capacitor is also slightly better, holding 12,000 units of energy, however the reactor is slower to recharge, at a rate \
	of 40 units."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core/recycling

/datum/technomancer/equipment/summoning
	name = "Summoning Core"
	desc = "A unique type of core, this one sacrifices other characteristics in order to optimize it for the purposes teleporting \
	entities from vast distances, and keeping them there.  Wearers of this core can maintain up to 30 summons at once, and the energy \
	demand for maintaining summons is severely reduced.  This comes at the price of capcitors that can only hold 8,000 units of energy, \
	a recharging rate of 35 energy, and no shielding from instability."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core/summoner

/datum/technomancer/equipment/hypo_belt
	name = "Hypo Belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment.  Comes with one of each hypo."
	cost = 50
	obj_path = /obj/item/weapon/storage/belt/medical/technomancer

/obj/item/weapon/storage/belt/medical/technomancer
	name = "hypo belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment."
	storage_slots = 8
	startswith = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ = 1,
				/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat = 1)

/datum/technomancer/equipment/belt_of_holding
	name = "Belt of Holding"
	desc = "A belt with a literal pocket which opens to a localized pocket of 'Blue-Space', allowing for more storage.  \
	The nature of the pocket allows for storage of larger objects than what is typical for other belts, and in larger quanities.  \
	It will also help keep your pants on."
	cost = 50
	obj_path = /obj/item/weapon/storage/belt/holding

/obj/item/weapon/storage/belt/holding
	name = "Belt of Holding"
	desc = "Can hold more than you'd expect."
	icon_state = "ems"
	max_w_class = ITEM_SIZE_NORMAL // Can hold normal sized items.
	storage_slots = 14	// Twice the capacity of a typical belt.
	max_storage_space = ITEM_SIZE_NORMAL * 14

/datum/technomancer/equipment/thermals
	name = "Thermoncle"
	desc = "A fancy monocle with a thermal optics lens installed.  Allows you to see people across walls."
	cost = 150
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle

/datum/technomancer/equipment/night_vision
	name = "Night Vision Goggles"
	desc = "Strategical goggles which will allow the wearer to see in the dark.  Perfect for the sneaky type, just get rid of the \
	lights first."
	cost = 50
	obj_path = /obj/item/clothing/glasses/night

/datum/technomancer/equipment/omni_sight
	name = "Omnisight Scanner"
	desc = "A very rare scanner worn on the face, which allows the wearer to see nearly anything across walls."
	cost = 300
	obj_path = /obj/item/clothing/glasses/omni

/obj/item/clothing/glasses/omni
	name = "Omnisight Scanner"
	desc = "A pair of goggles which, while on the surface appear to be build very poorly, reveal to be very advanced in \
	capabilities.  The lens appear to be multiple optical matrices layered together, allowing the wearer to see almost anything \
	across physical barriers."
	icon_state = "uzenwa_sissra_1"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	toggleable = 1
	vision_flags = SEE_TURFS|SEE_MOBS|SEE_OBJS
	prescription = 1 // So two versions of these aren't needed.

/datum/technomancer/equipment/med_hud
	name = "Medical HUD"
	desc = "A commonly available HUD for medical professionals, which displays how healthy an individual is.  \
	Recommended for support-based apprentices!"
	cost = 25
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle

/datum/technomancer/equipment/scepter
	name = "Scepter of Empowerment"
	desc = "A gem sometimes found in the depths of asteroids makes up the basis for this device.  Energy is channeled into it from \
	the Core and the user, causing many functions to be enhanced in various ways, so long as it is held in the off-hand.  \
	Be careful not to lose this!"
	cost = 200
	obj_path = /obj/item/weapon/scepter

/obj/item/weapon/scepter
	name = "scepter of empowerment"
	desc = "It's a purple gem, attached to a rod and a handle, along with small wires.  It looks like it would make a good club."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "scepter"
	force = 15
	slot_flags = SLOT_BELT

/obj/item/weapon/scepter/attack_self(mob/living/carbon/human/user)
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/S = item_to_test
		S.on_scepter_use_cast(user)

/obj/item/weapon/scepter/afterattack(atom/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(proximity_flag)
		return ..()
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/S = item_to_test
		S.on_scepter_ranged_cast(target, user)
