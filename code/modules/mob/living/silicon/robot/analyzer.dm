//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 200)
	origin_tech = "magnets=2;biotech=1;engineering=2"
	var/mode = 1;

/obj/item/device/robotanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	if(( (CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		user << text("\red You try to analyze the floor's vitals!")
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red [user] has analyzed the floor's vitals!"), 1)
		user.show_message(text("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy"), 1)
		user.show_message(text("\blue \t Damage Specifics: [0]-[0]-[0]-[0]"), 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	if(!istype(M, /mob/living/silicon/robot)) //todo add limb analysis
		user << "\red You can't analyze non-robotic things!"
		return

	user.visible_message("<span class='notice'> [user] has analyzed [M]'s components.","<span class='notice'> You have analyzed [M]'s components.")
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	user.show_message("\blue Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]")
	user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	if(M.tod && M.stat == DEAD)
		user.show_message("\blue Time of Disable: [M.tod]")

	if (istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/H = M
		var/list/damaged = H.get_damaged_components(1,1,1)
		user.show_message("\blue Localized Damage:",1)
		if(length(damaged)>0)
			for(var/datum/robot_component/org in damaged)
				user.show_message(text("\blue \t []: [][] - [] - [] - []",	\
				capitalize(org.name),					\
				(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
				(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	:0,	\
				(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
				(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
				(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
		else
			user.show_message("\blue \t Components are OK.",1)
		if(H.emagged && prob(5))
			user.show_message("\red \t ERROR: INTERNAL SYSTEMS COMPROMISED",1)

	user.show_message("\blue Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)

	src.add_fingerprint(user)
	return
