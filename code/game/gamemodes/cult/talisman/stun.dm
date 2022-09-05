/obj/item/paper/talisman/stun
	talisman_name = "stun"
	talisman_desc = "temporarily stuns a targeted mob with a blinding and disorienting flash of light"
	talisman_sound = 'sound/weapons/flash.ogg'
	valid_target_type = list(
		/mob/living/carbon,
		/mob/living/silicon,
		/mob/living/simple_animal
	)


/obj/item/paper/talisman/stun/get_antag_info()
	. = ..()
	. += {"
		<p>The stun talisman's effects can be blocked or mitigated by certain eye and face wear, similarly to a flash.</p>
	"}


/obj/item/paper/talisman/stun/invoke(mob/living/target, mob/user)
	var/obj/item/device/flash/flash = new(src)
	flash.do_flash(target)
	qdel(flash)
