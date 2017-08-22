
/obj/structure/sign/halo_floorsign
	name = "floorsign (bridge)"
	desc = "A floor decal detailing the direction of the bridge."
	icon_state = "bridge"
	icon = 'code/modules/halo/floorsigns/Hallwaymarkers.dmi'
	anchored = 1
	layer = 2

/obj/structure/sign/halo_floorsign/bridge

/obj/structure/sign/halo_floorsign/engineering
	name = "floorsign (engineering)"
	desc = "A floor decal detailing the direction of engineering."
	icon_state = "engineering"

/obj/structure/sign/halo_floorsign/armory
	name = "floorsign (armory)"
	desc = "A floor decal detailing the direction of an armory."
	icon_state = "armory"

/obj/structure/sign/halo_floorsign/cargobay
	name = "floorsign (cargobay)"
	desc = "A floor decal detailing the direction of a cargobay."
	icon_state = "cargobay"

/obj/structure/sign/halo_floorsign/cryobay
	name = "floorsign (cryobay)"
	desc = "A floor decal detailing the direction of a cryobay."
	icon_state = "cryobay"

/obj/structure/sign/halo_floorsign/airlock
	name = "floorsign (airlock)"
	desc = "A floor decal detailing the direction of an airlock."
	icon_state = "airlock"

/obj/structure/sign/halo_floorsign/maint
	name = "floorsign (maintenance)"
	desc = "A floor decal detailing the direction of a maintenance accessway."
	icon_state = "maint"

/obj/structure/sign/halo_floorsign/stairs
	name = "floorsign (stairs)"
	desc = "A floor decal detailing the direction of a stairwell."
	icon_state = "stairs"

/obj/structure/sign/halo_floorsign/hangar
	name = "floorsign (hangar)"
	desc = "A floor decal detailing the direction of a hangar."
	icon_state = "hangar"

/obj/structure/sign/halo_floorsign/lifepods
	name = "floorsign (lifepods)"
	desc = "A floor decal detailing the direction of a lifepod."
	icon_state = "lifepods"

/obj/structure/sign/deck1
	name = "\improper Deck 1"
	desc = "An informational sign informing the reader that they're currently on deck 1"
	icon_state = "deck1"

/obj/structure/sign/deck2
	name = "\improper Deck 2"
	desc = "An informational sign informing the reader that they're currently on deck 2"
	icon_state = "deck2"

/obj/structure/sign/deck3
	name = "\improper Deck 3"
	desc = "An informational sign informing the reader that they're currently on deck 3"
	icon_state = "deck3"

/obj/structure/sign/deck4
	name = "\improper Deck 4"
	desc = "An informational sign informing the reader that they're currently on deck 4"
	icon_state = "deck4"

/obj/structure/sign/deck5
	name = "\improper Deck 5"
	desc = "An informational sign informing the reader that they're currently on deck 5"
	icon_state = "deck5"

/obj/structure/sign/berth
	var/berth_num = 1
	var/berth_prefix = ""

/obj/structure/sign/berth/New()
	..()
	if(berth_prefix)
		name = "\improper [berth_prefix] Berth [berth_num]"
	else
		name = "\improper Berth [berth_num]"
	icon_state = "deck[berth_num]"
