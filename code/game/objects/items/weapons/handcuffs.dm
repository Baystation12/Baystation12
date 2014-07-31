/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter = list("metal" = 500)
	origin_tech = "materials=1"
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)
	if (!istype(user, /mob/living/carbon/human))
		user << "\red You don't have the dexterity to do this!"
		return
	if ((CLUMSY in usr.mutations) && prob(50))
		user << "\red Uh ... how do those things work?!"
		place_handcuffs(user, user)
		return
	if(!C.handcuffed)
		//check for an aggressive grab
		for (var/obj/item/weapon/grab/G in C.grabbed_by)
			if (G.loc == user && G.state == GRAB_AGGRESSIVE)
				place_handcuffs(C, user)
				return
		user << "\red You need to have a firm grip on [C] before you can put \the [src] on!"

/obj/item/weapon/handcuffs/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [H.name] ([H.ckey])</font>")
		msg_admin_attack("[key_name(user)] attempted to handcuff [key_name(H)]")

		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
		O.source = user
		O.target = H
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = H.loc
		O.place = "handcuff"
		H.requests += O
		spawn( 0 )
			feedback_add_details("handcuffs","H")
			O.process()
		return
	
	if (ismonkey(target))
		var/mob/living/carbon/monkey/M = target
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
		O.source = user
		O.target = M
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "handcuff"
		M.requests += O
		spawn( 0 )
			O.process()
		return

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != "hurt") return
	if (H.zone_sel.selecting != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/datum/organ/external/O = H.organs_by_name[H.hand?"l_hand":"r_hand"]
	if (!O) return

	var/s = "\red [H.name] chews on \his [O.display_name]!"
	H.visible_message(s, "\red You chew on your [O.display_name]!")
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
	log_attack("[s] ([H.ckey])")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'

/obj/item/weapon/handcuffs/cable/red
	color = "#DD0000"

/obj/item/weapon/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/weapon/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/weapon/handcuffs/cable/green
	color = "#00DD00"

/obj/item/weapon/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/weapon/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/weapon/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/weapon/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod
		R.use(1)

		user.put_in_hands(W)
		user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"
		del(src)
		update_icon(user)


/obj/item/weapon/handcuffs/cyborg
	dispenser = 1

/obj/item/weapon/handcuffs/cyborg/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(!C.handcuffed)
		var/turf/p_loc = user.loc
		var/turf/p_loc_m = C.loc
		playsound(src.loc, cuff_sound, 30, 1, -2)
		user.visible_message("\red <B>[user] is trying to put handcuffs on [C]!</B>")
		spawn(30)
			if(!C)	return
			if(p_loc == user.loc && p_loc_m == C.loc)
				C.handcuffed = new /obj/item/weapon/handcuffs(C)
				C.update_inv_handcuffed()