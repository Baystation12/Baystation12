/spell/mark_recall
	name = "Mark and Recall"
	desc = "This spell was created so wizards could get home from the bar without driving. Does not require wizard garb."
	feedback = "MK"
	school = "abjuration"
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

/spell/mark_recall/cast(var/list/targets,mob/user)
	if(!targets.len)
		return 0
	var/target = targets[1]
	if(istext(target))
		mark = new /obj/effect/cleanable/wizard_mark(get_turf(user),src)
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

	spell_flags = STATALLOWED

	return "You no longer have to be conscious to activate this spell."

/obj/effect/cleanable/wizard_mark
	name = "\improper Mark of the Wizard"
	desc = "A strange rune said to be made by wizards. Or its just some shmuck playing with crayons again."
	icon = 'icons/obj/rune.dmi'
	icon_state = "wizard_mark"

	anchored = 1
	unacidable = 1
	layer = TURF_LAYER

	var/spell/mark_recall/spell

/obj/effect/cleanable/wizard_mark/New(var/newloc,var/mrspell)
	..()
	spell = mrspell

/obj/effect/cleanable/wizard_mark/Destroy()
	spell.mark = null //dereference pls.
	spell = null
	..()

/obj/effect/cleanable/wizard_mark/attack_hand(var/mob/user)
	if(user == spell.holder)
		user.visible_message("\The [user] mutters an incantation and \the [src] disappears!")
		qdel(src)
	..()

/obj/effect/cleanable/wizard_mark/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/nullrod) || istype(I, /obj/item/weapon/spellbook))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		src.visible_message("\The [src] fades away!")
		qdel(src)
		return
	..()