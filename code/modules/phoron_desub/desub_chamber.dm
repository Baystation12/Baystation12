#define SM_CORE_SIZE 100

/obj/machinery/phoron_desublimer/resonant_chamber
	name = "resonant shamber"
	desc = "A machine capable of suspending supermatter stored within for safe transport."
	icon_state = "resonant_chamber"

	anchored = 1

	var/max_pieces = 8
	var/list/sm_pieces
	var/obj/item/weapon/metaphoron/catalyst = null
	var/health = 100

/obj/machinery/phoron_desublimer/resonant_chamber/Initialize()
	. = ..()
	LAZYINITLIST(sm_pieces)

/obj/machinery/phoron_desublimer/resonant_chamber/Destroy()
	QDEL_NULL_LIST(sm_pieces)
	QDEL_NULL(catalyst)
	. = ..()

/obj/machinery/phoron_desublimer/resonant_chamber/attackby(var/obj/item/weapon/B, var/mob/user)
	if(istype(B, /obj/item/weapon/wrench))
		if (!anchored)
			user.visible_message("[user] starts tightening the bolts on \the [src].", "You start tightening the bolts on \the [src].")
		else
			user.visible_message("[user] starts unfastening the bolts on \the [src].", "You start unfastening the bolts on \the [src].")

		if(do_after(user, 20, src))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			if (!anchored)
				anchored = 1
				user.visible_message("[user] tightens the bolts securing \the [src] to the floor.", "You tighten the bolts securing \the [src] to the floor.")
			else
				user.visible_message("[user] unfastens the bolts securing \the [src] to the floor.", "You unfasten the bolts securing \the [src] to the floor.")
				anchored = 0
		else
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(B.damtype == BRUTE || B.damtype == BURN)
				user.do_attack_animation(src)
			else
				playsound(loc, 'sound/effects/metalhit.ogg', 75, 1)
			health -= B.force
			if(health <= 0)
				qdel(src)
		return

	if(istype(B, /obj/item/weapon/material/shard/supermatter))
		if(sm_pieces.len < max_pieces)
			if(!user.drop_item())
				return
			B.forceMove(src)
			sm_pieces += B
			to_chat(user, "You put [B] into the machine.")
		else
			to_chat(user, "<span class='notice'>The machine is full!</span>")
	else if(istype(B, /obj/item/weapon/metaphoron))
		if(!catalyst)
			if(!user.drop_item())
				return
			catalyst = B
			to_chat(user, "You put [B] into the machine.")
		else
			to_chat(user, "<span class='notice'>There is already [catalyst] in the catalyst slot!</span>")
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(B.damtype == BRUTE || B.damtype == BURN)
			user.do_attack_animation(src)
		else
			playsound(loc, 'sound/effects/metalhit.ogg', 75, 1)
		health -= B.force
		if(health <= 0)
			qdel(src)
	return

/obj/machinery/phoron_desublimer/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				qdel(src)
			return

/obj/machinery/phoron_desublimer/resonant_chamber/Bumped(var/atom/movable/AM)
	if(anchored)
		if(istype(AM, /obj/machinery/power/supermatter))
			if(sm_pieces.len < max_pieces)
				var/obj/machinery/power/supermatter/SM = AM
				SM.forceMove(src)
				sm_pieces += SM
				src.visible_message("\icon[src] <b>[src]</b> beeps, \"[SM] loaded.\"")
			else
				src.visible_message("\icon[src] <b>[src]</b> beeps, \"Machine is too full to load \the [AM].\"")
	else
		..()

/obj/machinery/phoron_desublimer/resonant_chamber/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER) || active)
		return
	if(!anchored)
		to_chat(user, "The chamber needs to be secured to the floor before operating.")
		return
	var/choice = input(user,"What would you like to do?", \
							"Resonant Chamber", \
							"Cancel") in list("Combine", "Eject", "Eject Catalyst", "Cancel")
	if(user.incapacitated() || !user.Adjacent(loc) || !anchored || active)
		return
	switch(choice)
		if("Combine")
			if(!catalyst)
				to_chat(user, "The machine lacks a catalyst and cannot operate.")
			else if(!active)
				src.combine_SM()
		if("Eject")
			eject(user)
		if("Eject Catalyst")
			eject_catalyst(user)

/obj/machinery/phoron_desublimer/resonant_chamber/proc/combine_SM()
	var/total_size = 0
	active = 1

	playsound(loc, 'sound/effects/neutron_charge.ogg', 50, 1, -1)
	flick("resonant_chamber_on", src)
	for(var/sm_piece in sm_pieces)
		if(istype(sm_piece, /obj/item/weapon/material/shard/supermatter))
			var/obj/item/weapon/material/shard/supermatter/shard = sm_piece
			total_size += shard.size + (15*(shard.smlevel/MAX_SUPERMATTER_LEVEL)) // A max level shard will add +15 to its size
		if(istype(sm_piece, /obj/machinery/power/supermatter))
			var/obj/machinery/power/supermatter/core = sm_piece
			total_size += (SM_CORE_SIZE*core.smlevel) // A level 3 core is worth as many as three level 1 cores
	if(istype(catalyst, /obj/item/weapon/metaphoron/low))
		total_size = total_size/2
	for(var/sm_piece in sm_pieces)
		qdel(sm_piece)
	sm_pieces.Cut()
	if(total_size > SM_CORE_SIZE)
		var/smlevel = round(total_size/SM_CORE_SIZE)
		var/obj/machinery/power/supermatter/core = new(src, smlevel)
		sm_pieces += core
	else
		var/obj/item/weapon/metaphoron/shard = new(src, 1, total_size)
		sm_pieces += shard

	QDEL_NULL(catalyst)
	catalyst = null
	sleep(50)
	playsound(loc, 'sound/machines/ding.ogg', 50, 1, -1)
	active = 0

/obj/machinery/phoron_desublimer/resonant_chamber/proc/eject(mob/user as mob)
	var/obj/sm_piece = input(user,	"What would you like to eject?", \
									"Resonant Chamber", \
									null) in sm_pieces
	if(!CanPhysicallyInteract(user))
		return
	if(!sm_piece)
		return
	sm_piece.dropInto(loc)
	sm_pieces -= sm_piece

/obj/machinery/phoron_desublimer/resonant_chamber/proc/eject_catalyst(mob/user as mob)
	if(!catalyst)
		return

	catalyst.dropInto(loc)
	catalyst = null

#undef SM_CORE_SIZE
