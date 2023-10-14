/spell/aoe_turf/conjure/forcewall
	name = "Forcewall"
	desc = "Create a wall of pure energy at your location."
	school = "conjuration"
	feedback = "FW"
	summon_type = list(/obj/forcefield)
	duration = 300
	charge_max = 100
	spell_flags = 0
	range = 0
	cast_sound = 'sound/magic/forcewall.ogg'

	hud_state = "wiz_shield"

/spell/aoe_turf/conjure/forcewall/mime
	name = "Invisible wall"
	desc = "Create an invisible wall on your location."
	school = "mime"
	panel = "Mime"
	summon_type = list(/obj/forcefield/mime)
	invocation_type = SpI_EMOTE
	invocation = "mimes placing their hands on a flat surfacing, and pushing against it."
	charge_max = 300
	cast_sound = null

	override_base = "grey"
	hud_state = "mime_wall"

/obj/forcefield
	desc = "A space wizard's magic wall."
	name = "FORCEWALL"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield"
	anchored = TRUE
	opacity = 0
	density = TRUE
	unacidable = TRUE

/obj/forcefield/bullet_act(obj/item/projectile/Proj, def_zone)
	var/turf/T = get_turf(src.loc)
	if(T)
		for(var/mob/M in T)
			Proj.on_hit(M,M.bullet_act(Proj, def_zone))
	return

/obj/forcefield/mime
	icon_state = "empty"
	name = "invisible wall"
	desc = "You have a bad feeling about this."

/spell/aoe_turf/conjure/forcewall/tower
	charge_max = 3
