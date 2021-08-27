/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	desc = "A box of filled dough pockets. Great for a quick meal when you're hiding from Security. Instructions included on the box."
	item_cost = 8
	path = /obj/item/storage/box/sinpockets

/datum/uplink_item/item/medical/stabilisation
	name = "Stabilisation First Aid Kit"
	desc = "Contains variety of emergency medical pouches."
	item_cost = 16
	path = /obj/item/storage/firstaid/stab

/datum/uplink_item/item/medical/stasis
	name = "Stasis Bag"
	desc = "Reusable bag designed to slow down life functions of occupant, especially useful if short on time or in a hostile enviroment."
	item_cost = 24
	path = /obj/item/bodybag/cryobag

/datum/uplink_item/item/medical/defib
	name = "Combat Defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	item_cost = 24
	path = /obj/item/defibrillator/compact/combat/loaded

/datum/uplink_item/item/medical/surgery
	name = "Surgery Kit"
	desc = "Contains all the tools needed for on the spot surgery, assuming you actually know what you're doing with them. Floor sterilization not included."
	item_cost = 40
	path = /obj/item/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Combat Medical Kit"
	desc = "Contains most medicines you need to recover from injuries and illnesses, all in a convenient pill form. Splints for broken bones also included!"
	item_cost = 48
	path = /obj/item/storage/firstaid/combat

/datum/uplink_item/item/medical/scanner
	name = "Health Scanner"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	item_cost = 18
	path = /obj/item/device/scanner/health

/datum/uplink_item/item/medical/scanner
	name = "Health HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	item_cost = 18
	path = /obj/item/clothing/glasses/hud/health