
/obj/structure/electric_fence
	name = "chain fence"
	desc = "A protective fence created using metals and wiring. Electrified."
	icon = 'code/modules/halo/icons/machinery/fence.dmi'
	icon_state = "fence"
	density = 1
	anchored = 1

/obj/structure/electric_fence/Bump(var/mob/living/bumper)
	if(istype(bumper))
		bumper.adjustFireLoss(1)
		to_chat(bumper,"<span class = 'danger'>Electricity jumps from [src] as you near it, singing your body.</span>")
	. = ..()

/obj/structure/electric_fence/proc/attack_shock(var/mob/living/user)
	if(istype(user))
		user.adjustFireLoss(3)
		to_chat(user,"<span class = 'danger'>Electricity jumps from [src] as attack it, singing your body.</span>")

/obj/structure/electric_fence/attackby(var/atom/item,var/mob/living/user)
	attack_shock(user)

/obj/structure/electric_fence/attack_hand(var/mob/living/user)
	attack_shock(user)

/obj/structure/electric_fence/ns
	icon = 'code/modules/halo/icons/machinery/fence-ns.dmi'
	icon_state = "fence-ns"
	bound_height = 96

/obj/structure/electric_fence/ew
	icon = 'code/modules/halo/icons/machinery/fence-ew.dmi'
	icon_state = "fence-ew"
	bound_width = 96
