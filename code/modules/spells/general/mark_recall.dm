/spell/mark_recall
	name = "Mark and Recall"
	desc = "This spell was created so wizards could get home from the bar without driving. Does not require wizard garb."
	feedback = "MK"
	school = "conjuration"
	charge_max = 600 //1 minutes for how OP this shit is (apparently not as op as I thought)
	spell_flags = Z2NOCAST
	invocation = "Re-Alki R'natha."
	invocation_type = SpI_WHISPER
	cooldown_min = 300

	smoke_amt = 1
	smoke_spread = 5

	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 1)

	cast_sound = 'sound/effects/teleport.ogg'
	hud_state = "wiz_mark"
	var/mark = null

/spell/mark_recall/choose_targets()
	if(!mark)
		return list("magical fairy dust") //because why not
	else
		return list(mark)

/spell/mark_recall/cast(list/targets,mob/user)
	if(!length(targets))
		return 0
	var/target = targets[1]
	if(istext(target))
		mark = new /obj/cleanable/wizard_mark(get_turf(user),src)
		return 1
	if(!istype(target,/obj)) //something went wrong
		return 0
	var/turf/T = get_turf(target)
	if(!T)
		return 0
	user.forceMove(T)
	..()

/spell/mark_recall/empower_spell()
	if(!..())
		return 0

	spell_flags = NO_SOMATIC

	return "You will always be able to cast this spell, even while unconscious or handcuffed."

/obj/cleanable/wizard_mark
	name = "\improper Mark of the Wizard"
	desc = "A strange rune said to be made by wizards. Or its just some shmuck playing with crayons again."
	icon = 'icons/obj/rune.dmi'
	icon_state = "wizard_mark"

	anchored = TRUE
	unacidable = TRUE
	layer = TURF_LAYER

	var/spell/mark_recall/spell

/obj/cleanable/wizard_mark/New(newloc,mrspell)
	..()
	spell = mrspell

/obj/cleanable/wizard_mark/Destroy()
	spell.mark = null //dereference pls.
	spell = null
	..()

/obj/cleanable/wizard_mark/attack_hand(mob/user)
	if(user == spell.holder)
		user.visible_message("\The [user] mutters an incantation and \the [src] disappears!")
		qdel(src)
	..()


/obj/cleanable/wizard_mark/use_tool(obj/item/tool, mob/user, list/click_params)
	// Null Rod or Spell Book - Remove mark
	if (is_type_in_list(tool, list(/obj/item/nullrod, /obj/item/spellbook)))
		user.visible_message(
			SPAN_NOTICE("\The [user] waves \a [tool] over \the [src], and it fades away."),
			SPAN_NOTICE("You wave \the [tool] over \the [src], and it fades away.")
		)
		qdel(src)
		return TRUE

	return ..()
