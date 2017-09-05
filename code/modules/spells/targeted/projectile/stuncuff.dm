/spell/targeted/projectile/dumbfire/stuncuff
	name = "Stun Cuff"
	desc = "This spell fires out a small curse that stuns and cuffs the target."
	feedback = "SC"
	proj_type = /obj/item/projectile/spell_projectile/stuncuff

	charge_type = Sp_CHARGES
	charge_max = 6
	charge_counter = 6
	spell_flags = 0
	invocation = "Fu'Reai Diakan!"
	invocation_type = SpI_SHOUT
	range = 20

	level_max = list(Sp_TOTAL = 0, Sp_SPEED = 0, Sp_POWER = 0)

	duration = 20
	proj_step_delay = 1

	amt_stunned = 6

	hud_state = "wiz_cuff"

/spell/targeted/projectile/dumbfire/stuncuff/prox_cast(var/list/targets, spell_holder)
	for(var/mob/living/M in targets)
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/obj/item/weapon/handcuffs/wizard/cuffs = new()
			cuffs.forceMove(H)
			H.handcuffed = cuffs
			H.update_inv_handcuffed()
			H.visible_message("Beams of light form around \the [H]'s hands!")
		apply_spell_damage(M)


/obj/item/weapon/handcuffs/wizard
	name = "beams of light"
	desc = "Undescribable and unpenetrable. Or so they say."

	breakouttime = 300 //30 seconds

/obj/item/weapon/handcuffs/wizard/dropped(var/mob/user)
	..()
	qdel(src)

/obj/item/projectile/spell_projectile/stuncuff
	name = "stuncuff"
	icon_state = "spell"