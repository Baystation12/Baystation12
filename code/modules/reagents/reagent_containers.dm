/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = ITEM_SIZE_SMALL
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = "5;10;15;25;30"
	var/volume = 30
	var/label_text

/obj/item/reagent_containers/proc/cannot_interact(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(usr, "<span class='notice'>You're in no condition to do that!'</span>")
		return TRUE
	if(ismob(loc) && loc != user)
		to_chat(usr, "<span class='notice'>You can't set transfer amounts while [src] is being held by someone else.</span>")
		return TRUE
	return FALSE

/obj/item/reagent_containers/verb/set_amount_per_transfer_from_this()
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(1)
	if (cannot_interact(usr))
		return
	var/N = input("Amount per transfer from this:","[src]") as null|anything in cached_number_list_decode(possible_transfer_amounts)
	if (cannot_interact(usr)) // because input takes time and the situation can change
		return
	if(N)
		amount_per_transfer_from_this = N

/obj/item/reagent_containers/New()
	create_reagents(volume)
	..()
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/reagent_containers/verb/set_amount_per_transfer_from_this

/obj/item/reagent_containers/attack_self(mob/user as mob)
	return

/obj/item/reagent_containers/afterattack(obj/target, mob/user, flag)
	return

/obj/item/reagent_containers/proc/reagentlist() // For attack logs
	if(reagents)
		return reagents.get_reagents()
	return "No reagent holder"

/obj/item/reagent_containers/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>The label can be at most 10 characters long.</span>")
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
	else
		return ..()

/obj/item/reagent_containers/proc/update_name_label()
	if(label_text == "")
		SetName(initial(name))
	else
		SetName("[initial(name)] ([label_text])")

/obj/item/reagent_containers/proc/standard_dispenser_refill(mob/user, obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, "<span class='notice'>[target] is empty.</span>")
		return 1

	if(reagents && !reagents.get_free_space())
		to_chat(user, "<span class='notice'>[src] is full.</span>")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")
	return 1

/obj/item/reagent_containers/proc/standard_splash_mob(mob/user, mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(user.a_intent == I_HELP)
		to_chat(user, "<span class='notice'>You can't splash people on help intent.</span>")
		return 1

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(target.reagents && !target.reagents.get_free_space())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/contained = reagentlist()
	if (reagents.should_admin_log())
		admin_attack_log(user, target, "Used \the [name] containing [contained] to splash the victim.", "Was splashed by \the [name] containing [contained].", "used \the [name] containing [contained] to splash")

	user.visible_message("<span class='danger'>[target] has been splashed with something by [user]!</span>", "<span class = 'notice'>You splash the solution onto [target].</span>")
	reagents.splash(target, reagents.total_volume)
	return 1

/obj/item/reagent_containers/proc/splashtarget(obj/target, mob/user)
	if (user.a_intent == I_HURT)
		if (standard_splash_mob(user,target))
			return TRUE
		if (reagents && reagents.total_volume)
			user.visible_message(
				SPAN_NOTICE("\The [user] splashes \the [src] onto \the [target]."),
				SPAN_NOTICE("You splash the contents of \the [src] onto \the [target]."),
				SPAN_NOTICE("You hear the sound of liquid splashing.")
			)
			reagents.splash(target, reagents.total_volume)
			return TRUE

/obj/item/reagent_containers/proc/self_feed_message(mob/user)
	to_chat(user, "<span class='notice'>You eat \the [src]</span>")

/obj/item/reagent_containers/proc/other_feed_message_start(mob/user, mob/target)
	user.visible_message("<span class='warning'>[user] is trying to feed [target] \the [src]!</span>")

/obj/item/reagent_containers/proc/other_feed_message_finish(mob/user, mob/target)
	user.visible_message("<span class='warning'>[user] has fed [target] \the [src]!</span>")

/obj/item/reagent_containers/proc/feed_sound(mob/user)
	return

/obj/item/reagent_containers/proc/standard_feed_mob(mob/living/user, mob/living/carbon/human/target)
	if (!istype(target))
		return FALSE
	if(!reagents || !reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return TRUE
	if (user?.a_intent == I_HURT)
		return FALSE
	var/is_self = target == user
	if (!target.check_has_mouth())
		to_chat(user, SPAN_WARNING("[is_self ? "You" : "\The [target]"] can't consume \the [src] - [is_self ? "you" : "they"] don't have a mouth!"))
		return FALSE
	var/obj/item/blocker = target.check_mouth_coverage()
	if (blocker)
		to_chat(user, SPAN_WARNING("[is_self ? "Your" : "\The [target]'s"] [blocker] is in the way!"))
		return FALSE
	user?.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (is_self)
		self_feed_message(target)
		add_trace_DNA(target)
	else
		other_feed_message_start(user, target)
		if (!do_after(user, 3 SECONDS, target, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			return FALSE
		other_feed_message_finish(user, target)
		add_trace_DNA(target)
		var/contained = reagentlist()
		admin_attack_log(user, target, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")
	feed_sound(target)
	var/transfer_amount = target.species?.ingest_amount || 10
	if (user.a_intent == I_DISARM)
		transfer_amount = Ceil(transfer_amount * 0.5)
	else if (user.a_intent == I_GRAB)
		transfer_amount = Ceil(transfer_amount * 1.5)
	reagents.trans_to_mob(target, transfer_amount, CHEM_INGEST)
	return TRUE


/obj/item/reagent_containers/proc/standard_pour_into(mob/user, atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!target.is_open_container() && istype(target, /obj/item/reagent_containers))
		to_chat(user, "<span class='notice'>\The [target] is closed.</span>")
		return 1
	// Otherwise don't care about splashing.
	else if(!target.is_open_container())
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(!target.reagents.get_free_space())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	playsound(src, 'sound/effects/pour.ogg', 25, 1)
	to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to \the [target].  \The [src] now contains [src.reagents.total_volume] units.</span>")
	return 1

/obj/item/reagent_containers/do_surgery(mob/living/carbon/M, mob/living/user)
	if(user.zone_sel.selecting != BP_MOUTH) //in case it is ever used as a surgery tool
		return ..()

/obj/item/reagent_containers/AltClick(mob/user)
	if(possible_transfer_amounts)
		set_amount_per_transfer_from_this()
	else
		return ..()

/obj/item/reagent_containers/examine(mob/user)
	. = ..()
	if(!reagents)
		return
	if(hasHUD(user, HUD_SCIENCE))
		var/prec = user.skill_fail_chance(SKILL_CHEMISTRY, 10)
		to_chat(user, "<span class='notice'>The [src] contains: [reagents.get_reagents(precision = prec)].</span>")
	else if((loc == user) && user.skill_check(SKILL_CHEMISTRY, SKILL_EXPERT))
		to_chat(user, "<span class='notice'>Using your chemistry knowledge, you identify the following reagents in \the [src]: [reagents.get_reagents(!user.skill_check(SKILL_CHEMISTRY, SKILL_PROF), 5)].</span>")

/obj/item/reagent_containers/ex_act(severity)
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			R.ex_act(src, severity)
	..()
