/obj/structure/closet/crate/secure/biohazard/blanks
	name = "vatgrown storage chamber"
	desc = "A sleeper filled with blue liquid. You think you see something moving inside."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "redpod1"
	icon_opened = "redpod0"
	icon_closed = "redpod1"
	//Plays sound/effects/smoke.ogg while opening as well.
	anchored = 1
	flags = null
	var/sealed = 1

/obj/structure/closet/crate/secure/biohazard/blanks/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0
	if(sealed)
		playsound(src.loc, 'sound/effects/smoke.ogg', 20)
		visible_message("<span class='notice'>\The [src] begins to depressurize!</span>")
		sleep(30)
		var/L = get_step(src.loc, SOUTH)
		new /obj/effect/decal/cleanable/cryojuice(L)
		src.sealed = 0
		src.icon_closed = "Redpod-off"
	src.dump_contents()
	src.opened = 1
	playsound(src.loc, open_sound, 15, 1 ,-3)
	update_icon()
	return 1

/obj/structure/closet/crate/secure/biohazard/blanks/WillContain()
	return list(/mob/living/carbon/human/blank)

/obj/structure/closet/crate/secure/biohazard/blanks/slice_into_parts(obj/item/weapon/weldingtool/WT, mob/user)
	to_chat(user, "<span class='notice'>\The [src] is too strong to be taken apart.</span>")