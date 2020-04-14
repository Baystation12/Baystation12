
/obj/structure/jump_pad
	name = "Covenant Jump Pad"
	desc = "A high power jump pad that will send you somewhere on the ship."
	icon = 'grav32.dmi'
	icon_state = "jumppad"
	density = 0
	anchored = 1
	layer = 2.9
	var/list/linked_turfs = list()
	var/id

/obj/structure/jump_pad/Initialize()
	. = ..()
	for(var/obj/effect/landmark/jump_pad_target/D in world)
		if(D.id == src.id)
			linked_turfs.Add(D.loc)

/obj/structure/jump_pad/attack_hand(var/mob/M)
	attempt_jump(M)

/obj/structure/jump_pad/Crossed(atom/movable/O)
	attempt_jump(O)

/obj/structure/jump_pad/proc/attempt_jump(var/mob/living/carbon/human/O)
	. = ..()
	if(O && istype(O) && linked_turfs.len && O.loc in range(1,src))
		if(alert(O,"Warning: this is a one way trip and you should wait until your team is ready. Are you ready to go?",\
			"[src]","Ascend jump pad","Remain below") == "Ascend jump pad")
			var/turf/target = pick(linked_turfs)
			O.loc = target
			O.visible_message("<span class='info'>[O] slams into [target], propelled through the air by a great force!</span>",\
				"<span class='info'>You hurtle through the air, slamming into [target]!</span>")

/obj/effect/landmark/jump_pad_target
	name = "jump pad destination"
	icon_state = "x"
	var/id
