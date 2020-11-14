
/////////
// Implants
/////////
/obj/item/weapon/implant/translator/natural/ascent
	origin_tech = list(TECH_BIO = 10)
	learning_threshold = 1
	max_languages = 25 //Absolutely not required, but whatever.

/obj/item/weapon/implantcase/ascent
	name = "glass case - 'operative translation device'"
	imp = /obj/item/weapon/implant/translator/natural/ascent

/obj/item/weapon/storage/box/ascentimplants
	name = "operative translators"
	desc = "Box of stuff used to implant translation software, designed to sync up with the Mantid physiology."
	icon_state = "implant"
	item_state = "syringe_kit"
	startswith = list(/obj/item/weapon/implanter = 1,
				/obj/item/weapon/implantcase/ascent = 12)


/////////
// Human Oxygen Reactor
/////////
/obj/item/weapon/tank/mantid/reactor/oxygen/captives
	name = "captive gas reactor"
	desc = "Creates a near infinite supply of oxygen, best given to captives, rather than yourself."
	color = "#3b88bf"
	refill_gas_type = GAS_OXYGEN
	distribute_pressure = 21


/////////
// purple greytide box and shiz
/////////
/obj/item/weapon/storage/toolbox/ascent
	name = "odd toolbox"
	icon_state = "syndicate"
	item_state = "toolbox_syndi"
	color = "#3b88bf"
	startswith = list(/obj/item/clustertool, /obj/item/weapon/weldingtool/electric/mantid, /obj/item/weapon/crowbar/brace_jack/ascent, /obj/item/device/multitool/mantid)

//crowbar
/obj/item/weapon/crowbar/brace_jack/ascent
	name = "odd maintenance jack"
	desc = "A special crowbar that can be used to safely remove airlock braces from airlocks. \
	This one appears oddly weighted."
	color = "#3b88bf"
	w_class = ITEM_SIZE_NORMAL

//lamp
/obj/item/device/flashlight/lamp/floodlamp/ascent
	name = "odd lamp"
	color = "#a33fbf" //Just makes it look really, really odd. But it's funny, so, y'know.

/////////
// Ascent Shield/Batterer
/////////
/obj/item/device/personal_shield/mantid
	name = "personal shield"
	desc = "Truely a life-saver: this device protects its user from being hit by objects moving very, very fast, though only for a few shots."
	icon = 'icons/obj/device.dmi'
	icon_state = "batterer"
	color = "#a33fbf"
	uses = 15

//batterer
/obj/item/device/batterer/mantid
	name = "mantid mind batterer"
	desc = "A strange device with twin antennas."
	icon_state = "batterer"
	item_state = "electronic"
	max_uses = 5000//It'll never be elsewhere, and this is a safeguard against burnout, given the cooldown. If they somehow still burn it out, well, Jesus. I 'unno.

