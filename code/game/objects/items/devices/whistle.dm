/obj/item/device/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon = 'icons/obj/hailer.dmi'
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = ITEM_SIZE_TINY
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	var/use_message = "Halt! Security!"
	var/spamcheck = 0
	var/insults

/obj/item/device/hailer/verb/set_message()
	set name = "Set Hailer Message"
	set category = "Object"
	set desc = "Alter the message shouted by your hailer."

	if(!isnull(insults))
		to_chat(usr, "The hailer is fried. The tiny input screen just shows a waving ASCII penis.")
		return

	var/new_message = input(usr, "Please enter new message (leave blank to reset).") as text
	if(!new_message || new_message == "")
		use_message = "Halt! Security!"
	else
		use_message = capitalize(copytext_char(sanitize(new_message), 1, MAX_MESSAGE_LEN))

	to_chat(usr, "You configure the hailer to shout \"[use_message]\".")

/obj/item/device/hailer/attack_self(mob/living/carbon/user as mob)
	if (spamcheck)
		return

	if(isnull(insults))
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)
		user.audible_message("<span class='warning'>[user]'s [name] rasps, \"[use_message]\"</span>", null, "<span class='warning'>\The [user] holds up \the [name].</span>")
	else
		to_chat(user, "<span class='danger'>*BZZZZZZZZT*</span>")

	spamcheck = 1
	spawn(20)
		spamcheck = 0

/obj/item/device/hailer/emag_act(var/remaining_charges, var/mob/user)
	if(isnull(insults))
		to_chat(user, "<span class='danger'>You overload \the [src]'s voice synthesizer.</span>")
		insults = rand(1, 3)//to prevent dickflooding
		return 1
	else
		to_chat(user, "The hailer is fried. You can't even fit the sequencer into the input slot.")
