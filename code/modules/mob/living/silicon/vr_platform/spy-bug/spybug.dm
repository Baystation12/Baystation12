/mob/living/silicon/platform/spybug
	name = "bug"
	real_name = "spy bug"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spy-bug"
	maxHealth = 1
	health = 1
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = PASSTABLE
	density = 1
	local_transmit = 1

	//Used for self-mailing.
	var/mail_destination = ""

	holder_type = /obj/item/weapon/holder/spybug

/mob/living/silicon/platform/spybug/New()
	//Generates a semi-unique string
	real_name = "[name]-[rand(1, 1000)]"

	verbs += /mob/living/proc/hide

	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 0)
	universal_understand = 1

	//Some tidying-up.
	flavor_text = "An annoying little buzzing bug."
	updateicon()

	..()


/mob/living/silicon/platform/spybug/updateicon()
	return

//spybugs cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/platform/spybug/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/borg/upgrade/))
		user << "\red The spy bug chassis not compatible with \the [W]."
		return

	else if (istype(W, /obj/item/weapon/crowbar))
		user << "The spy bug is too small to be pried open!"
		return

	..()

//spybug LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/platform/spybug/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return


/mob/living/silicon/platform/spybug/Process_Spaceslipping(var/prob_slip)
	return 1 // Spybugs can't fly in space, now can they?

/*
//Reboot procs.
/mob/living/silicon/platform/spybug/proc/transfer_personality(var/client/player)

	if(!player) return

	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		user_body = player.mob
		player.mob.mind.transfer_to(src)

	src << "Loading flight controls ..."
	spawn(5)
		src<< "<b>Loaded</b>."
		src << "Welcome pilot. Enjoy your flight."
*/

/mob/living/silicon/platform/spybug/Bump(atom/movable/AM as mob|obj, yes)
	if (!yes || ( \
	 !istype(AM,/obj/machinery/door) && \
	 !istype(AM,/obj/machinery/recharge_station) && \
	 !istype(AM,/obj/machinery/disposal/deliveryChute) && \
	 !istype(AM,/obj/machinery/teleport/hub) && \
	 !istype(AM,/obj/effect/portal)
	)) return
	..()
	return

/mob/living/silicon/platform/spybug/Bumped(AM as mob|obj)
	return

/mob/living/silicon/platform/spybug/start_pulling(var/atom/movable/AM)
	if(istype(AM,/obj/item))
		var/obj/item/O = AM
		if(O.w_class > 0)
			src << "<span class='warning'>You are too small to pull that.</span>"
			return
		else
			..()
	else
		src << "<span class='warning'>You are too small to pull that.</span>"
		return



var/list/spybot_verbs_default = list(
	/mob/living/silicon/platform/spybug/verb/set_mail_tag
)