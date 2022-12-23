/spell/targeted/projectile/dumbfire/fireball
	name = "Fireball"
	desc = "This spell fires a fireball at a target and does not require wizard garb."
	feedback = "FB"
	proj_type = /obj/item/projectile/spell_projectile/fireball

	school = "conjuration"
	charge_max = 10 SECONDS
	spell_flags = 0
	invocation = "Oni-Soma!"
	invocation_type = SpI_SHOUT
	range = 20

	level_max = list(Sp_TOTAL = 5, Sp_SPEED = 0, Sp_POWER = 5)

	spell_flags = 0

	duration = 20
	proj_step_delay = 1

	amt_dam_brute = 20
	amt_dam_fire = 25

	var/explosion_radius = 3
	var/explosion_max_power = EX_ACT_HEAVY

	hud_state = "wiz_fireball"
	cast_sound = 'sound/magic/fireball.ogg'

/spell/targeted/projectile/dumbfire/fireball/prox_cast(list/targets, spell_holder)
	for(var/mob/living/M in targets)
		apply_spell_damage(M)
	explosion(get_turf(spell_holder), explosion_radius, explosion_max_power)

/spell/targeted/projectile/dumbfire/fireball/empower_spell()
	if(!..())
		return 0

	if(spell_levels[Sp_POWER]%2 == 1)
		explosion_radius += 1
		explosion_max_power = max(explosion_max_power - 1, EX_ACT_DEVASTATING) // Increase max power
	explosion_radius += 2

	return "The spell [src] now has a larger explosion."

/spell/targeted/projectile/dumbfire/fireball/tower
	charge_max = 2

//PROJECTILE

/obj/item/projectile/spell_projectile/fireball
	name = "fireball"
	icon_state = "fireball"

/spell/targeted/projectile/dumbfire/fireball/firebolt
	name = "Firebolt"
	desc = "A quick-casted fireball. Burns the user, and their enemies, but is much faster to shoot."
	feedback = "FO"
	charge_type = Sp_HOLDVAR
	invocation = "Ignus!"
	holder_var_type = "fireloss"
	holder_var_amount = 10
	amt_dam_brute = 10
	amt_dam_fire = 15
	explosion_radius = 1
	explosion_max_power = EX_ACT_LIGHT
	hud_state = "firebolt"
