//Analyzer, pestkillers, weedkillers, nutrients, hatchets.


/obj/item/device/analyzer/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"

	attack_self(mob/user as mob)
		return 0


// *************************************
// Pestkiller defines for hydroponics
// *************************************

/obj/item/pestkiller
	name = "bottle of pestkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	var/toxicity = 0
	var/PestKillStr = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/carbaryl
	name = "bottle of carbaryl"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	toxicity = 4
	PestKillStr = 2
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/lindane
	name = "bottle of lindane"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	toxicity = 6
	PestKillStr = 4
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/pestkiller/phosmet
	name = "bottle of phosmet"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	toxicity = 8
	PestKillStr = 7
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

// *************************************
// Hydroponics Tools
// *************************************

/obj/item/weapon/weedspray // -- Skie
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon = 'icons/obj/hydroponics.dmi'
	name = "weed-spray"
	icon_state = "weedspray"
	item_state = "spray"
	flags = TABLEPASS | OPENCONTAINER | FPRINT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/WeedKillStr = 2

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (TOXLOSS)

/obj/item/weapon/pestspray // -- Skie
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon = 'icons/obj/hydroponics.dmi'
	name = "pest-spray"
	icon_state = "pestspray"
	item_state = "spray"
	flags = TABLEPASS | OPENCONTAINER | FPRINT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/PestKillStr = 2

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is huffing the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (TOXLOSS)

/obj/item/weapon/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	flags = FPRINT | TABLEPASS | CONDUCT | NOBLUDGEON
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	matter = list("metal" = 50)
	attack_verb = list("slashed", "sliced", "cut", "clawed")


// *************************************
// Weedkiller defines for hydroponics
// *************************************

/obj/item/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	var/toxicity = 0
	var/WeedKillStr = 0

/obj/item/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	toxicity = 4
	WeedKillStr = 2

/obj/item/weedkiller/lindane
	name = "bottle of triclopyr"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	toxicity = 6
	WeedKillStr = 4

/obj/item/weedkiller/D24
	name = "bottle of 2,4-D"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	toxicity = 8
	WeedKillStr = 7


// *************************************
// Nutrient defines for hydroponics
// *************************************

/obj/item/nutrient
	name = "bottle of nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	w_class = 2.0
	var/mutmod = 0
	var/yieldmod = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/ez
	name = "bottle of E-Z-Nutrient"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT |  TABLEPASS
	mutmod = 1
	yieldmod = 1
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/l4z
	name = "bottle of Left 4 Zed"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT |  TABLEPASS
	mutmod = 2
	yieldmod = 0
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)

/obj/item/nutrient/rh
	name = "bottle of Robust Harvest"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT |  TABLEPASS
	mutmod = 0
	yieldmod = 2
	New()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)


//Hatchets and things to kill kudzu
/obj/item/weapon/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 12.0
	w_class = 2.0
	throwforce = 15.0
	throw_speed = 4
	throw_range = 4
	sharp = 1
	edge = 1	
	matter = list("metal" = 15000)
	origin_tech = "materials=2;combat=1"
	attack_verb = list("chopped", "torn", "cut")

/obj/item/weapon/hatchet/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

//If it's a hatchet it goes here. I guess
/obj/item/weapon/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")


/obj/item/weapon/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force = 13.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 3
	w_class = 4.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	slot_flags = SLOT_BACK
	origin_tech = "materials=2;combat=2"
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/weapon/scythe/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /obj/effect/spacevine))
		for(var/obj/effect/spacevine/B in orange(A,1))
			if(prob(80))
				del B
		del A