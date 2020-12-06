/spell/contract/return_master
	name = "Return to Master"
	desc = "Teleport back to your master"

	school = "conjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	cooldown_min = 200

	smoke_spread = 1
	smoke_amt = 5

	hud_state = "wiz_tele"


/spell/contract/return_master/cast(mob/target,mob/user)
	target = ..(target,user)
	if(!target)
		return

	user.forceMove(get_turf(target))