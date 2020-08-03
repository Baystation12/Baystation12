
/obj/machinery/slipspace_engine/proc/user_remove_core(var/mob/user)
	to_chat(user,"<span class = 'warning'>You start removing the core from [src] for mobile core detonation...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY * 3, src, same_direction = 1))
		return
	core_removed = TRUE
	new core_to_spawn(loc)
	visible_message("<span class = 'warning'>[user] removes the core from [src] for mobile core detonation.</span>")

//CORE PAYLOADS//
/obj/payload/slipspace_core
	name = "Slipspace Core"
	desc = "The core of a slipspace device, detached and armed."
	icon_state = "core"
	activeoverlay =  "core_active"
	w_class = ITEM_SIZE_HUGE
	free_explode = 1
	do_arm_disarm_alert = 0
	explodetype = /datum/explosion/slipspace_core
	seconds_to_explode = 300 //5 minutes to explode.
	seconds_to_disarm = 30 // 30 sesconds to disarm.

/obj/payload/slipspace_core/attack_hand(var/mob/living/carbon/human/user)
	. = ..()
	if(exploding && !disarming)
		for(var/mob/player in GLOB.mobs_in_sectors[map_sectors["[z]"]])
			to_chat(player,"<span class = 'danger'>UNSTABLE SLIPSPACE SIGNATURE DETECTED AT [loc.loc] ([x],[y],[z]). STABALISE SIGNATURE OR SUPERSTRUCTURE FAILURE WILL BE IMMINENT.</span>")

/datum/explosion/slipspace_core/New(var/obj/payload/b)
	if(config.oni_discord)
		message2discord(config.oni_discord, "Alert: slipspace core detonation detected. [b.name] @ ([b.loc.x],[b.loc.y],[b.loc.z])")
	var/obj/effect/overmap/om = map_sectors["[b.z]"]
	if(isnull(om))
		return
	explosion(get_turf(b),5,7,10,15)
	om.pre_superstructure_failing()
