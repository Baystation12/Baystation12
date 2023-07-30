/obj/item/psychic_power
	name = "psychic power"
	icon = 'icons/obj/psychic_powers.dmi'
	atom_flags = 0
	anchored = TRUE
	var/maintain_cost = 3
	var/mob/living/owner

/obj/item/psychic_power/New(mob/living/_owner)
	owner = _owner
	if (!istype(owner))
		qdel(src)
		return
	START_PROCESSING(SSprocessing, src)
	..()

/obj/item/psychic_power/Destroy()
	if (istype(owner) && owner.psi)
		LAZYREMOVE(owner.psi.manifested_items, src)
		UNSETEMPTY(owner.psi.manifested_items)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/psychic_power/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/psychic_power/attack_self(mob/user)
	sound_to(owner, 'sound/effects/psi/power_fail.ogg')
	user.drop_from_inventory(src)

/obj/item/psychic_power/attack(mob/living/M, mob/living/user, target_zone)
	if (M.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, SPAN_DANGER("\The [src] flickers violently out of phase!"))
		return 1
	. = ..()

/obj/item/psychic_power/afterattack(atom/target, mob/living/user, proximity)
	if (target.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, SPAN_DANGER("\The [src] flickers violently out of phase!"))
		return
	. = ..(target, user, proximity)

/obj/item/psychic_power/dropped()
	..()
	qdel(src)

/obj/item/psychic_power/Process()
	if (istype(owner))
		owner.psi.spend_power(maintain_cost)
	if (!owner || owner.do_psionics_check(maintain_cost, owner) || !owner.IsHolding(src))
		if (istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if (istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if (O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		else
			qdel(src)
