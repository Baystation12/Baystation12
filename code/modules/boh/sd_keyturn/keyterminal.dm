#define KEYTERMINAL_STATE_SAFE "stage0"
#define KEYTERMINAL_STATE_ACTIVE "stage1"
#define KEYTERMINAL_STATE_ARMED "stage2"

/obj/machinery/sd_keyterminal
	name = "self destruct key terminal"
	desc = "A wallmounted terminal for authorizing the self-destruct device's activation."
	icon = 'icons/boh/obj/key_terminal.dmi'
	icon_state = "keyturn_terminal"
	var/obj/item/weapon/sd_key/key //The key that's been inserted into us.
	var/state = KEYTERMINAL_STATE_SAFE
	var/slave = FALSE //we're not the one who initialized the request for a keyturn.
	var/obj/machinery/sd_keyterminal/master_terminal //used for keyturning gubbins.
	var/obj/machinery/sd_keyterminal/slave_terminal
	var/mob/living/carbon/human/master_term_user
	var/recieved_signal = FALSE

/obj/machinery/sd_keyterminal/Initialize() //Whichever terminal initializes first is the 'master', anything else is the 'slave'. The keyturn must be initiated from the 'master'.
	. = ..()
	update_stage(TRUE)
	if(!slave)
		for(var/obj/machinery/sd_keyterminal/SDK in world)
			if(SDK == src)
				continue
			else
				SDK.slave = TRUE
				slave_terminal = SDK
				SDK.master_terminal = src
				SDK.name = "[initial(name)] (Beta)"
				name = "[initial(name)] (Alpha)"

/obj/machinery/sd_keyterminal/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/sd_key))
		var/obj/item/weapon/sd_key/newkey = O
		insert_key(newkey, user)

/obj/machinery/sd_keyterminal/attack_hand(mob/user)
	if(key)
		var/list/answer_list = list("Turn Key", "Remove Key")
		var/answer = input("What do you want to do?", "Keyterminal Prompt") as null|anything in answer_list
		if(answer == "Turn Key")
			switch(state)
				if(KEYTERMINAL_STATE_ARMED)
					to_chat(user, SPAN_NOTICE("You turn the key, lowering [src]'s state down to active."))
					state = KEYTERMINAL_STATE_ACTIVE
					update_stage()
				if(KEYTERMINAL_STATE_ACTIVE)
					if(slave)
						if(user == master_term_user)
							visible_message(SPAN_WARNING("[src] beeps, 'Authentication rejected: source and slave biosigns match.'"))
							return
						if(!recieved_signal)
							return
					to_chat(user, SPAN_WARNING("You turn the key, raising [src]'s state to armed."))
					recieved_signal = FALSE
					state = KEYTERMINAL_STATE_ARMED
					update_stage()
					if(!slave)
						broadcast_keyturn(user)
		else if(answer == "Remove Key")
			remove_key(user)

/obj/machinery/sd_keyterminal/proc/insert_key(var/obj/item/O, mob/user)
	var/obj/item/weapon/sd_key/newkey = O //this assumes the istype is already passed
	to_chat(user, SPAN_NOTICE("You press the key against [src]'s keyslot, waiting for it to check the authentication..."))
	if(!user.unEquip(newkey, src))
		return
	if(newkey.skeleton_key == FALSE) //skeleton keys skip all the authentication stuff.
		if(newkey.owner)
			visible_message(SPAN_NOTICE("[src] beeps, 'Authentication accepted: [newkey.owner], [newkey.job_name].'"))
		else
			visible_message(SPAN_WARNING("[src] beeps, 'Authentication rejected: key not registered.'"))
			return
	newkey.forceMove(src)
	key = O
	to_chat(user, SPAN_NOTICE("You slot the key into [src]."))
	state = KEYTERMINAL_STATE_ACTIVE
	update_stage()

/obj/machinery/sd_keyterminal/proc/remove_key(mob/user)
	if(state == KEYTERMINAL_STATE_ARMED)
		to_chat(user, SPAN_WARNING("You can't remove the key when [src] is in this state. Turn it first."))
		return
	user.put_in_hands(key)
	key = null
	to_chat(user, SPAN_NOTICE("You remove the key from [src]."))
	state = KEYTERMINAL_STATE_SAFE
	update_stage()

/obj/machinery/sd_keyterminal/proc/update_stage(var/silent = FALSE)
	switch(state)
		if(KEYTERMINAL_STATE_SAFE)
			if(!silent)
				visible_message(SPAN_NOTICE("[src] beeps, 'Notice: Key terminal state is now: SAFE.'"))
			set_light(0.5, 1, 2, 2, "#32ff00")
		if(KEYTERMINAL_STATE_ACTIVE)
			if(!silent)
				visible_message(SPAN_WARNING("[src] beeps, 'Caution: Key terminal state is now: ACTIVE.'"))
				playsound(src.loc, 'sound/effects/alarm7.ogg', 25, 0, 10)
			set_light(0.5, 1, 2, 2, "#fff300")
		if(KEYTERMINAL_STATE_ARMED)
			if(!silent)
				visible_message(SPAN_DANGER("[src] beeps, 'Alert: Key terminal state is now: ARMED.'"))
				playsound(src.loc, 'sound/effects/siren1b.ogg', 25, 0, 10)
			set_light(0.5, 1, 2, 2, "#ff0000")
	update_icon()

/obj/machinery/sd_keyterminal/proc/broadcast_keyturn(var/mob/living/carbon/human/master_turner)
	slave_terminal.recieve_keyturn(master_turner)

/obj/machinery/sd_keyterminal/proc/recieve_keyturn(var/mob/living/carbon/human/master_turner)
	master_term_user = master_turner
	recieved_signal = TRUE
	if(!key.skeleton_key)
		if(state == KEYTERMINAL_STATE_SAFE)
			master_terminal.visible_message(SPAN_WARNING("[master_terminal] beeps, 'Caution: Slave terminal is not in proper state. Aborting.'"))
			master_terminal.state = KEYTERMINAL_STATE_ACTIVE
			master_terminal.update_stage(TRUE)
			recieved_signal = FALSE
			return //no point if the other terminal is safed.

		//now check if they keys are unique.
		if(master_terminal.key.owner == key.owner) //Can't have two of the same key, of course.
			master_terminal.state = KEYTERMINAL_STATE_ACTIVE
			master_terminal.update_stage(TRUE)
			master_terminal.visible_message(SPAN_WARNING("[master_terminal] beeps, 'Caution: Authentication failed, source key and slave key are similar. Aborting.'"))
			recieved_signal = FALSE
			return

		sleep(4 SECONDS) //have a nap while waiting for the keyturn - uniqueness of the turning mob is checked in the attack_hand proc.

		if(state == KEYTERMINAL_STATE_ARMED)
			master_terminal.confirm_keyturn()
			master_terminal.visible_message(SPAN_WARNING("[master_terminal] beeps, 'Notice: Authentication accepted.'"))
		else
			master_terminal.state = KEYTERMINAL_STATE_ACTIVE
			master_terminal.update_stage(TRUE)
			master_term_user = null //don't need it after this point.
			recieved_signal = FALSE
	else
		master_terminal.confirm_keyturn()

/obj/machinery/sd_keyterminal/proc/confirm_keyturn()
	for(var/obj/machinery/nuclearbomb/station/SDmaster in world)
		SDmaster.keyturn_recieved = TRUE

/obj/machinery/sd_keyterminal/on_update_icon()
	overlays.Cut()
	overlays += image('icons/boh/obj/key_terminal.dmi', "keyturn_[state]")
	if(key)
		overlays += image('icons/boh/obj/key_terminal.dmi', "keyactive_[key.ownertag]")