/atom/proc/water_act(var/depth, var/flowdir)
	return

/obj/item/water_act(var/depth, var/flowdir)
	if(!isnull(flowdir))
		if(anchored || depth <= w_class*10)
			return
		step_towards(src, get_step(get_turf(src),flowdir))

/mob/living/water_act(var/depth, var/flowdir)
	if(on_fire)
		visible_message("<span class='danger'>A cloud of steam rises up as the water hits \the [src]!</span>")
		ExtinguishMob()
	if(fire_stacks > 0)
		adjust_fire_stacks(-round(depth/2))
	if(anchored || buckled)
		return
	if(!isnull(flowdir))
		if(depth >= FLUID_DROWN_LEVEL_RESTING)
			var/flow_msg = "pushed away"
			if(!lying && depth >= FLUID_DROWN_LEVEL_STANDING && prob(depth))
				Weaken(rand(2,4))
				flow_msg = "knocked down"
			src << "<span class='danger'>You are [flow_msg] by the rush of water!</span>"
			step_towards(src, get_step(get_turf(src),flowdir))

/mob/living/carbon/human/water_act(var/depth, var/flowdir)
	species.water_act(src, depth)
	if(!((species.flags & NO_SLIP) || (shoes && (shoes.flags & NOSLIP))))
		..(depth, flowdir)

/datum/species/proc/water_act(var/mob/living/carbon/human/H, var/depth)
	return

/datum/species/skrell/water_act(var/mob/living/carbon/human/H, var/depth)
	..()
	if(depth >= 40)
		if(H.traumatic_shock)
			H.traumatic_shock -= 25 // Slightly more than being drunk because it fires less often (10 ticks as opposed to 4)
		if(H.getBruteLoss() || H.getFireLoss())
			H.adjustBruteLoss(-(rand(1,3)))
			H.adjustFireLoss(-(rand(1,3)))
		if(prob(5)) // Might be too spammy.
			H << "<span class='notice'>The water ripples gently over your skin in a soothing balm.</span>"

/obj/effect/decal/cleanable/water_act()
	qdel(src)

/obj/effect/decal/cleanable/blood/water_act()
	..()
	var/obj/effect/fluid/F = locate() in loc
	if(!F) return
	F.add_contaminant("blood", amount, basecolor)