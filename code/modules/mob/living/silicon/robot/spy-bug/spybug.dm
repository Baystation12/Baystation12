/mob/living/silicon/robot/spybug
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
	braintype = "Robot"
	lawupdate = 0
	density = 1
	integrated_light_power = 2
	local_transmit = 1

	//Used for self-mailing.
	var/mail_destination = ""

	var/mob/living/user_body

	holder_type = /obj/item/weapon/holder/spybug

/mob/living/silicon/robot/spybug/New()

	..()

	verbs += /mob/living/proc/hide

	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 0)

	//They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN.
	mmi = null

	//We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 1

	//Some tidying-up.
	flavor_text = "What is THAT?!"
	updateicon()

/mob/living/silicon/robot/spybug/init()
	laws = null
	connected_ai = null

	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)


/mob/living/silicon/robot/spybug/updateicon()
	return

/mob/living/silicon/robot/spybug/choose_icon()
	return

/mob/living/silicon/robot/spybug/pick_module()
	return

//spybugs cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/spybug/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W, /obj/item/borg/upgrade/))
		user << "\red The spy bug chassis not compatible with \the [W]."
		return

	else if (istype(W, /obj/item/weapon/crowbar))
		user << "The spy bug is too small to be pried open!"
		return

	..()

//spybug LIFE/DEATH

//For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/spybug/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

//Easiest to check this here, then check again in the robot proc.
//Standard robots use config for crit, which is somewhat excessive for these guys.
//spybugs killed by damage will gib.
/mob/living/silicon/robot/spybug/handle_regular_status_updates()

	if(health <= -maxHealth && src.stat != 2)
		timeofdeath = world.time
		death() //Possibly redundant, having trouble making death() cooperate.
		gib()
		return
	..()

//spybug MOVEMENT.
/mob/living/silicon/robot/spybug/Process_Spaceslipping(var/prob_slip)
	//TODO: Consider making a magboot item for spybugs to equip. ~Z
	return 0


//Reboot procs.
/mob/living/silicon/robot/spybug/proc/transfer_personality(var/client/player)

	if(!player) return

	src.ckey = player.ckey

	if(player.mob && player.mob.mind)
		user_body = player.mob
		player.mob.mind.transfer_to(src)

	lawupdate = 0
	src << "Loading flgiht controls ..."
	sleep(5)
	verbs += spybot_verbs_default
	src<< "<b>Loaded</b>."
	src << "Welcome pilot. Enjoy your flight."


/mob/living/silicon/robot/spybug/Bump(atom/movable/AM as mob|obj, yes)
	if (!yes || ( \
	 !istype(AM,/obj/machinery/door) && \
	 !istype(AM,/obj/machinery/recharge_station) && \
	 !istype(AM,/obj/machinery/disposal/deliveryChute) && \
	 !istype(AM,/obj/machinery/teleport/hub) && \
	 !istype(AM,/obj/effect/portal)
	)) return
	..()
	return

/mob/living/silicon/robot/spybug/Bumped(AM as mob|obj)
	return

/mob/living/silicon/robot/spybug/start_pulling(var/atom/movable/AM)
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

/mob/living/silicon/robot/spybug/add_robot_verbs()

/mob/living/silicon/robot/spybug/remove_robot_verbs()

var/list/spybot_verbs_default = list(
	/mob/living/silicon/robot/spybug/verb/disconnect,
	/mob/living/silicon/robot/spybug/verb/set_mail_tag
)