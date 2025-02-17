/obj/item/autopsy_scanner
	name = "post-mortem analysis unit"
	desc = "A Zeng-Hu design, refabricated and adopted by the majority of Sol and Gilgamesh. \
			A tool for morticians, coroners and detectives."
	icon = 'icons/obj/surgery_tools.dmi'
	icon_state = "autopsy_scanner"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

	var/mob/living/carbon/human/target = null
	var/target_name = null
	var/timeofdeath = null
	var/display_string = ""


/obj/item/autopsy_scanner/verb/print_data()
	set category = "Object"
	set src in view(usr, 1)
	set name = "Print Data"
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		to_chat(usr, "No.")
		return

	for(var/mob/O in viewers(usr))
		O.show_message(SPAN_NOTICE("\The [src] rattles and prints out a sheet of paper."), 1)

	playsound(loc, "sound/machines/dotprinter.ogg", 25, 1)
	sleep(6)
	var/a_data = ""
	if(timeofdeath)
		a_data += "<b>Time of death:</b> [worldtime2stationtime(timeofdeath)]<br><br>"
	a_data += display_string
	var/obj/item/paper/P = new(usr.loc, "<tt>[a_data]</tt>", "Autopsy Data ([target_name])")
	if(istype(usr,/mob/living/carbon))
		// place the item in the usr's hand if possible
		usr.put_in_hands(P)


/obj/item/autopsy_scanner/do_surgery(mob/living/carbon/human/M, mob/living/user)
	if(!istype(M))
		return FALSE

	if(M.stat != DEAD && !(M.status_flags & FAKEDEATH))
		FEEDBACK_FAILURE(user, "The patient is still alive. Aborting.")
		return FALSE

	set_target(M, user)
	timeofdeath = M.timeofdeath
	target = M

	var/obj/item/organ/external/S = M.get_organ(user.zone_sel.selecting)
	if(!S)
		FEEDBACK_FAILURE(user, "You can't scan this body part.")
		return
	if(!S.how_open())
		FEEDBACK_FAILURE(user, "You have to cut [S] open first!")
		return

	if (!user.do_skilled(2 SECONDS, SKILL_MEDICAL, S, do_flags = DO_MEDICAL))
		FEEDBACK_FAILURE(user, "You could not conduct the autopsy on \the [S].")

	M.visible_message(SPAN_NOTICE("\The [user] scans the wounds on [M]'s [S.name] with [src]"))

	display_string = M.GetWoundString(S)

	return TRUE


/obj/item/autopsy_scanner/proc/set_target(mob/new_target, user)
	if(target_name != new_target.name)
		target_name = new_target.name
		timeofdeath = null
		to_chat(user, SPAN_NOTICE("A new patient has been registered. Purging data for previous patient."))

	return target


/obj/item/autopsy_scanner/attack_self(mob/user)
	print_data(user)
