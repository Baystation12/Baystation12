/mob/living/silicon/platform
	var/mob/living/user_body // Keeping track of who the controller is
	var/active = 0 // Platforms start out inactive
	health = 100
	maxHealth = 100
	var/charge = 10000
	var/charge_capacity = 10000
	var/power_consumption = 10

/mob/living/silicon/platform/proc/init()
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)

/mob/living/silicon/platform/Life()
	set invisibility = 0

	src.blinded = null

	update_connection()

	//Status updates, death etc.
	handle_regular_status_updates()

	if (src.stat != DEAD) //still using power
		use_power()

//Easiest to check this here, then check again in the platform proc.
/mob/living/silicon/platform/proc/handle_regular_status_updates()
	if(health <= -maxHealth && src.stat != 2)
		timeofdeath = world.time
		death() //Possibly redundant, having trouble making death() cooperate.
		gib()
		return
	..()

/mob/living/silicon/platform/proc/use_power()
	if(charge == 0 )
		return

	charge = charge-power_consumption

/mob/living/silicon/platform/proc/update_connection()
	if( charge <= 0 )
		usr << "Connection lost due to insufficient power."
		platform_disconnect()

	if( health <= 0 )
		usr << "Connection lost due to critical damage."
		platform_disconnect()

	if( !active )
		usr << "Connection lost due to unknown error."
		platform_disconnect()

/mob/living/silicon/platform/proc/add_platform_verbs()
	verbs += platform_verbs_default

/mob/living/silicon/platform/proc/remove_platform_verbs()
	verbs -= platform_verbs_default
