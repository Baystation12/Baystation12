//////////////////////////////Construct Spells/////////////////////////

/spell/aoe_turf/conjure/construct
	name = "Artificer"
	desc = "This spell conjures a construct which may be controlled by Shades."

	school = "conjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/constructshell)

	hud_state = "artificer"
	cast_sound = 'sound/items/Deconstruct.ogg'

/spell/aoe_turf/conjure/construct/lesser
	charge_max = 1800
	summon_type = list(/obj/structure/constructshell/cult)
	hud_state = "const_shell"
	override_base = "const"

/spell/aoe_turf/conjure/floor
	name = "Floor Construction"
	desc = "This spell constructs a cult floor."

	charge_max = 20
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/floor/cult)

	hud_state = "const_floor"
	cast_sound = 'sound/items/Welder.ogg'

/spell/aoe_turf/conjure/wall
	name = "Lesser Construction"
	desc = "This spell constructs a cult wall."

	charge_max = 100
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/wall/cult)

	hud_state = "const_wall"
	cast_sound = 'sound/items/Welder.ogg'

/spell/aoe_turf/conjure/wall/reinforced
	name = "Greater Construction"
	desc = "This spell constructs a reinforced metal wall."

	charge_max = 300
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	cast_delay = 50

	summon_type = list(/turf/simulated/wall/r_wall)
	cast_sound = 'sound/items/Welder.ogg'

/spell/aoe_turf/conjure/soulstone
	name = "Summon Soulstone"
	desc = "This spell reaches into Nar-Sie's realm, summoning one of the legendary fragments across time and space."

	charge_max = 3000
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/item/device/soulstone)

	hud_state = "const_stone"
	override_base = "const"
	cast_sound = 'sound/items/Welder.ogg'

/spell/aoe_turf/conjure/pylon
	name = "Red Pylon"
	desc = "This spell conjures a fragile crystal from Nar-Sie's realm. Makes for a convenient light source."

	charge_max = 200
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/pylon)

	hud_state = "const_pylon"
	cast_sound = 'sound/items/Welder.ogg'

/spell/aoe_turf/conjure/forcewall/lesser
	name = "Shield"
	desc = "Allows you to pull up a shield to protect yourself and allies from incoming threats"

	charge_max = 300
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/obj/effect/forcefield/cult)
	duration = 200

	hud_state = "const_juggwall"
	cast_sound = 'sound/magic/forcewall.ogg'

//Code for the Juggernaut construct's forcefield, that seemed like a good place to put it.
/obj/effect/forcefield/cult
	name = "juggernaut shield"
	desc = "An eerie-looking obstacle that seems to have been pulled from another dimension through sheer force."
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield_cult"
	light_color = "#b40000"
	light_outer_range = 2
