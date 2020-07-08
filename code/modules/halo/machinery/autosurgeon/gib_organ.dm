
/obj/machinery/autosurgeon/proc/gib_organ(var/obj/item/organ/O, var/major_organ = FALSE)
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/do_move = TRUE

	if(major_organ)
		var/obj/effect/decal/cleanable/blood/gibs/core/C = locate() in get_turf(src)
		if(C)
			decal_type = /obj/effect/decal/cleanable/blood/gibs
		else
			do_move = FALSE
			decal_type = /obj/effect/decal/cleanable/blood/gibs/core

	//create the splatter
	var/obj/effect/decal/cleanable/blood/B = new decal_type(get_turf(src))

	//set the blood colour
	B.basecolor = O.species.get_blood_colour()

	//if necessary, set the flesh colour
	if(istype(B, /obj/effect/decal/cleanable/blood/gibs))
		var/obj/effect/decal/cleanable/blood/gibs/G = B
		G.fleshcolor = O.species.get_flesh_colour()

	//finalise the visual appearance
	B.update_icon()

	//set the DNA for forensic purposes (hehe)
	B.blood_DNA[O.dna.unique_enzymes] = O.dna.b_type

	//delete the source organ
	qdel(O)

	//squelch!
	playsound(get_turf(src), 'sound/effects/blobattack.ogg', 100, TRUE)

	//whoops it went flying!
	if(do_move)
		spawn(2)
			var/turf/dest = get_random_turf_in_range(src, 5, 1)
			step_to(B, dest)

			//spill blood on anyone nearby
			for(var/mob/living/carbon/human/M in range(src,1))
				to_chat(M,"<span class='warning'>You are showered with gore from [src].</span>")
				M.bloody_body(src)
				M.bloody_hands(src)
				if(M.wear_mask)
					M.wear_mask.add_blood(src)
					M.update_inv_wear_mask(0)
				if(M.head)
					M.head.add_blood(src)
					M.update_inv_head(0)
				if(M.glasses)
					M.glasses.add_blood(src)
					M.update_inv_glasses(0)
