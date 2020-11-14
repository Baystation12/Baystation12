/////////
// Blocker
/////////
/obj/blocker
	name = null
	density = 1
	anchored = 1
	unacidable = 1
	invisibility = 101

/////////
// Cannon Placeholders
/////////
/obj/structure/gunnery
	anchored = 1
	density = 1
	layer = BELOW_OBJ_LAYER
	w_class = ITEM_SIZE_NO_CONTAINER

/obj/structure/gunnery/railgun
	name = "SPECTRA"
	icon = 'icons/boh/structures/railgun.dmi'
	icon_state = "Railgun"
	desc = "A SPECTRA class helical railgun. SPECTRA standing for 'Super Capacity Helical Railgun'. \
	It appears to be in a state of disrepair, rendering it unsafe to fire in its current state."

/obj/structure/gunnery/torp
	name = "Torpedo tube"
	icon = 'icons/boh/structures/railgun.dmi'
	icon_state = "torpedo_loaded"
	desc = "A dismounted torpedo tube."

/obj/structure/gunnery/ob
	name = "KOSMAG"
	icon = 'icons/boh/structures/railgun.dmi'
	icon_state = "OBC"
	desc = "Easily the most deadly weapon aboard the vessel, this cannon fires an assortment of projectiles. \
	Primarily, it fires inert rods, earning the technical name 'Kinetic Orbital Strike Munition Assault Gun'. Or, in an easier to state form, the 'KOSMAG'."

/////////
// Munition Belt
/////////
/obj/machinery/conveyor/ammobelt
	name = "munition belt"
	id = "ammobelt1"

/obj/machinery/conveyor_switch/ammobelt
	name = "munition belt switch"
	id = "ammobelt1"

/////////
// MIM
/////////
/obj/machinery/missile_interceptor_mainframe_broken
	name = "missile interception mainframe"
	desc = "A massive bank of computers and ammunition storages, intended to control and feed a point defense cannon array. This example appears to be nonfunctional and in a state of disrepair."
	icon = 'icons/boh/structures/pointdefensemainframe.dmi'
	icon_state = "pdc_mainframe"
	anchored = 1
	density = 1

/obj/structure/mim_ammo_broken
	name = "pdc autoloader"
	desc = "A huge hunk of machinery and circuitry designed to feed point defense cannons ammunition. Seems broken."
	icon = 'icons/boh/structures/pointdefensemainframe.dmi'
	density = 1
	anchored = 1
	var/direction //totally unrelated to 'dir'. Used for aesthetics.

/obj/structure/mim_ammo_broken/left
	direction = "left"

/obj/structure/mim_ammo_broken/right
	direction = "right"

/obj/structure/mim_ammo_broken/Initialize()
	. = ..()
	icon_state = "pdc_[direction]"