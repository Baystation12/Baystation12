/obj/item/weapon/gun/launcher/money
	name = "money cannon"
	desc = "A blocky, plastic novelty launcher that claims to be able to shoot money at considerable velocities."
	icon_state = "money_launcher"
	item_state = "money_launcher"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	release_force = 80
	fire_sound_text = "a whoosh and a crisp, papery rustle"
	fire_delay = 1
	fire_sound = 'sound/weapons/gunshot/money_launcher.ogg'
	var/emagged = 0

	var/receptacle_value = 0
	var/dispensing = 20

/obj/item/weapon/gun/launcher/money/hacked
	emagged = 1

/obj/item/weapon/gun/launcher/money/proc/vomit_cash(var/mob/vomit_onto, var/projectile_vomit)
	var/bundle_worth = Floor(receptacle_value / 10)
	var/turf/T = get_turf(vomit_onto)
	for(var/i = 1 to 10)
		var/nv = bundle_worth
		if (i <= (receptacle_value - 10 * bundle_worth))
			nv++
		if (!nv)
			break
		var/obj/item/weapon/spacecash/bundle/bling = new(T)
		bling.worth = nv
		bling.update_icon()
		if(projectile_vomit)
			for(var/j = 1, j <= rand(2, 4), j++)
				step(bling, pick(GLOB.cardinal))

	if(projectile_vomit)
		vomit_onto.AdjustStunned(3)
		vomit_onto.AdjustWeakened(3)
		vomit_onto.visible_message("<span class='danger'>\The [vomit_onto] blasts themselves full in the face with \the [src]!</span>")
		playsound(T, "sound/weapons/gunshot/money_launcher_jackpot.ogg", 100, 1)
	else
		vomit_onto.visible_message("<span class='danger'>\The [vomit_onto] ejects a few [GLOB.using_map.local_currency_name] into their face.</span>")
		playsound(T, 'sound/weapons/gunshot/money_launcher.ogg', 100, 1)

	receptacle_value = 0

/obj/item/weapon/gun/launcher/money/proc/make_it_rain(var/mob/user)
	vomit_cash(user, receptacle_value >= 10)

/obj/item/weapon/gun/launcher/money/update_release_force()
	if(!emagged)
		release_force = 0
		return

	// Must launch at least 100 thaler to incur damage.
	release_force = dispensing / 100

/obj/item/weapon/gun/launcher/money/proc/unload_receptacle(mob/user)
	if(receptacle_value < 1)
		to_chat(user, "<span class='warning'>There's no money in [src].</span>")
		return

	var/obj/item/weapon/spacecash/bling = new /obj/item/weapon/spacecash/bundle()
	bling.worth = receptacle_value
	bling.update_icon()
	user.put_in_hands(bling)
	to_chat(user, "<span class='notice'>You eject [receptacle_value] [GLOB.using_map.local_currency_name_singular] from [src]'s receptacle.</span>")
	receptacle_value = 0

/obj/item/weapon/gun/launcher/money/proc/absorb_cash(var/obj/item/weapon/spacecash/bling, mob/user)
	if(!istype(bling) || !bling.worth || bling.worth < 1)
		to_chat(user, "<span class='warning'>[src] refuses to pick up [bling].</span>")
		return

	src.receptacle_value += bling.worth
	to_chat(user, "<span class='notice'>You load [bling] into [src].</span>")
	qdel(bling)

/obj/item/weapon/gun/launcher/money/consume_next_projectile(mob/user=null)
	if(!receptacle_value || receptacle_value < 1)
		return null

	var/obj/item/weapon/spacecash/bling = new /obj/item/weapon/spacecash/bundle()
	if(receptacle_value >= dispensing)
		bling.worth = dispensing
		receptacle_value -= dispensing
	else
		bling.worth = receptacle_value
		receptacle_value = 0

	bling.update_icon()
	update_release_force(bling.worth)
	if(release_force >= 1)
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()

	return bling

/obj/item/weapon/gun/launcher/money/attack_self(mob/user as mob)
	var/disp_amount = min(input(user, "How many [GLOB.using_map.local_currency_name_singular] do you want to dispense at a time? (0 to [src.receptacle_value])", "Money Cannon Settings", 20) as num, receptacle_value)

	if (disp_amount < 1)
		to_chat(user, "<span class='warning'>You have to dispense at least one [GLOB.using_map.local_currency_name_singular] at a time!</span>")
		return

	src.dispensing = disp_amount
	to_chat(user, "<span class='notice'>You set [src] to dispense [dispensing] [GLOB.using_map.local_currency_name_singular] at a time.</span>")

/obj/item/weapon/gun/launcher/money/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_receptacle(user)
	else
		return ..()

/obj/item/weapon/gun/launcher/money/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash/))
		var/obj/item/weapon/spacecash/bling = W
		if(bling.worth < 1)
			to_chat(user, "<span class='warning'>You can't seem to get the bills to slide into the receptacle.</span>")
			return

		receptacle_value += bling.worth
		to_chat(user, "<span class='notice'>You slide [bling.worth] [GLOB.using_map.local_currency_name_singular] into [src]'s receptacle.</span>")
		qdel(bling)

	else
		to_chat(user, "<span class='warning'>That's not going to fit in there.</span>")

/obj/item/weapon/gun/launcher/money/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to dispense [dispensing] [GLOB.using_map.local_currency_name_singular] at a time.")

	if(receptacle_value >= 1)
		to_chat(user, "The receptacle is loaded with [receptacle_value] [GLOB.using_map.local_currency_name_singular].")

	else
		to_chat(user, "The receptacle is empty.")

	if(emagged)
		to_chat(user, "<span class='notice'>Its motors are severely overloaded.</span>")

/obj/item/weapon/gun/launcher/money/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/M = user
	M.visible_message("<span class='danger'>[user] sticks [src] in their mouth, ready to pull the trigger...</span>")

	if(!do_after(user, 40, progress = 0))
		M.visible_message("<span class='notice'>[user] decided life was worth living.</span>")
		return

	src.make_it_rain(user)

/obj/item/weapon/gun/launcher/money/emag_act(var/remaining_charges, var/mob/user)
	// Overloads the motors, causing it to shoot money harder and do harm.
	if(!emagged)
		emagged = 1
		to_chat(user, "<span class='notice'>You slide the sequencer into [src]... only for it to spit it back out and emit a motorized squeal!</span>")
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()
	else
		to_chat(user, "<span class='notice'>[src] seems to have been tampered with already.</span>")