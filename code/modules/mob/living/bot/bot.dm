/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	universal_speak = 1
	density = 0
	var/obj/item/weapon/card/id/botcard = null
	var/list/botcard_access = list()
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = 0
	var/light_strength = 3

	var/obj/access_scanner = null
	var/list/req_access = list()
	var/list/req_one_access = list()

/mob/living/bot/New()
	..()
	update_icons()

	botcard = new /obj/item/weapon/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()
	access_scanner.req_one_access = req_one_access.Copy()

/mob/living/bot/Life()
	..()
	if(health <= 0)
		death()
		return
	weakened = 0
	stunned = 0
	paralysis = 0
	update_canmove()

/mob/living/bot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getFireLoss() - getBruteLoss()
	oxyloss = 0
	toxloss = 0
	cloneloss = 0
	halloss = 0

/mob/living/bot/death()
	explode()

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)
	if(O.GetID())
		if(access_scanner.allowed(user) && !open && !emagged)
			locked = !locked
			user << "<span class='notice'>Controls are now [locked ? "locked." : "unlocked."]</span>"
			attack_hand(user)
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "<span class='warning'>Please close the access panel before locking it.</span>"
			else
				user << "<span class='warning'>Access denied.</span>"
		return
	else if(istype(O, /obj/item/weapon/screwdriver))
		if(!locked)
			open = !open
			user << "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>"
		else
			user << "<span class='notice'>You need to unlock the controls first.</span>"
		return
	else if(istype(O, /obj/item/weapon/weldingtool))
		if(health < maxHealth)
			if(open)
				health = min(maxHealth, health + 10)
				user.visible_message("<span class='notice'>[user] repairs [src].</span>","<span class='notice'>You repair [src].</span>")
			else
				user << "<span class='notice'>Unable to repair with the maintenance panel closed.</span>"
		else
			user << "<span class='notice'>[src] does not need a repair.</span>"
		return
	else if (istype(O, /obj/item/weapon/card/emag) && !emagged)
		Emag(user)
		return
	else
		..()

/mob/living/bot/attack_ai(var/mob/user)
	return attack_hand(user)

/mob/living/bot/say(var/message)
	var/verb = "beeps"

	message = sanitize(message)

	..(message, null, verb)

/mob/living/bot/Bump(var/atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/proc/Emag(var/mob/user)
	log_and_message_admins("emagged [src]")
	return

/mob/living/bot/proc/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(light_strength)
	update_icons()
	return 1

/mob/living/bot/proc/turn_off()
	on = 0
	set_light(0)
	update_icons()

/mob/living/bot/proc/explode()
	qdel(src)
