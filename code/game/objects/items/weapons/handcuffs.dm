/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 2
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/elastic
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"



/obj/item/weapon/handcuffs/get_icon_state(mob/user_mob, slot)
	if(slot == slot_handcuffed_str)
		return "handcuff1"
	if(slot == slot_legcuffed_str)
		return "legcuff1"
	return ..()

/obj/item/weapon/handcuffs/attack(var/mob/living/carbon/C, var/mob/living/user)

	if(!user.IsAdvancedToolUser())
		return

	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Uh ... how do those things work?!</span>")
		place_handcuffs(user, user)
		return

	// only carbons can be handcuffed
	if(istype(C))
		if(!C.handcuffed)
			if (C == user)
				place_handcuffs(user, user)
				return

			//check for an aggressive grab (or robutts)
			if(can_place(C, user))
				place_handcuffs(C, user)
			else
				to_chat(user, "<span class='danger'>You need to have a firm grip on [C] before you can put \the [src] on!</span>")
		else
			to_chat(user, "<span class='warning'>\The [C] is already handcuffed!</span>")
	else
		..()

/obj/item/weapon/handcuffs/proc/can_place(var/mob/target, var/mob/user)
	if(user == target || istype(user, /mob/living/silicon/robot) || istype(user, /mob/living/bot))
		return 1
	else
		for (var/obj/item/grab/G in target.grabbed_by)
			if (G.force_danger())
				return 1
	return 0

/obj/item/weapon/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		return 0

	if (!H.has_organ_for_slot(slot_handcuffed))
		to_chat(user, "<span class='danger'>\The [H] needs at least two wrists before you can cuff them together!</span>")
		return 0

	if(istype(H.gloves,/obj/item/clothing/gloves/rig) && !elastic) // Can't cuff someone who's in a deployed hardsuit.
		to_chat(user, "<span class='danger'>\The [src] won't fit around \the [H.gloves]!</span>")
		return 0

	user.visible_message("<span class='danger'>\The [user] is attempting to put [cuff_type] on \the [H]!</span>")

	if(!do_after(user,30, target))
		return 0

	if(!can_place(target, user)) // victim may have resisted out of the grab in the meantime
		return 0

	admin_attack_log(user, H, "Attempted to handcuff the victim", "Was target of an attempted handcuff", "attempted to handcuff")
	feedback_add_details("handcuffs","H")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	var/obj/item/weapon/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(get_turf(user))
	else
		user.drop_from_inventory(cuffs)
	target.equip_to_slot(cuffs,slot_handcuffed)
	return 1

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != I_HURT) return
	if (H.zone_sel.selecting != BP_MOUTH) return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[(H.hand ? BP_L_HAND : BP_R_HAND)]
	if (!O) return

	H.visible_message("<span class='warning'>\The [H] chews on \his [O.name]!</span>", "<span class='warning'>You chew on your [O.name]!</span>")
	admin_attacker_log(H, "chewed on their [O.name]!")

	O.take_damage(3,0, DAM_SHARP|DAM_EDGE ,"teeth marks")

	last_chew = world.time

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"
	elastic = 1

/obj/item/weapon/handcuffs/cable/red
	color = COLOR_MAROON

/obj/item/weapon/handcuffs/cable/yellow
	color = COLOR_AMBER

/obj/item/weapon/handcuffs/cable/blue
	color = COLOR_CYAN_BLUE

/obj/item/weapon/handcuffs/cable/green
	color = COLOR_GREEN

/obj/item/weapon/handcuffs/cable/pink
	color = COLOR_PURPLE

/obj/item/weapon/handcuffs/cable/orange
	color = COLOR_ORANGE

/obj/item/weapon/handcuffs/cable/cyan
	color = COLOR_SKY_BLUE

/obj/item/weapon/handcuffs/cable/white
	color = COLOR_SILVER

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/material/wirerod/W = new(get_turf(user))
			user.put_in_hands(W)
			to_chat(user, "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>")
			qdel(src)
			update_icon(user)

/obj/item/weapon/handcuffs/cyborg
	dispenser = 1

/obj/item/weapon/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 200
	cuff_type = "duct tape"