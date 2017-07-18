/obj/item/device/soulstone
	name = "soul stone shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'."
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)

	var/full = 0 // 0 = empty, 1 = has essence, -1 = cracked
	var/is_evil = 1
	var/mob/living/simple_animal/shade = null
	var/smashing = 0
	var/soulstatus = null

/obj/item/device/soulstone/full
	full = 1
	icon_state = "soulstone2"

/obj/item/device/soulstone/New()
	..()
	shade = new /mob/living/simple_animal/shade(src)

/obj/item/device/soulstone/Destroy()
	qdel_null(shade)
	return ..()

/obj/item/device/soulstone/examine(mob/user)
	. = ..()
	if(full == 0)
		icon_state = "soulstone"
		to_chat(user, "The shard still flickers with a fraction of the full artifacts power.")
	if(full == 1)
		to_chat(user,"The shard has gone transparent, a seeming window into a dimension of unspeakable horror.")
	if(full == -1)
		to_chat(user, "This one is cracked and useless.")

/obj/item/device/soulstone/update_icon()
	if(full == 0)
		icon_state = "soulstone"
	if(full == 1)
		icon_state = "soulstone2" //TODO: A spookier sprite. Also unique sprites.
	if(full == -1)
		icon_state = "soulstone"//TODO: cracked sprite
		name = "cracked soulstone"

/obj/item/device/soulstone/attackby(var/obj/item/I, var/mob/user)
	..()
	if(is_evil && istype(I, /obj/item/weapon/nullrod))
		to_chat(user, "<span class='notice'>You cleanse \the [src] of taint, purging its shackles to its creator..</span>")
		is_evil = 0
		return
	if(I.force > 10)
		if(!smashing)
			to_chat(user, "<span class='notice'>\The [src] looks fragile. Are you sure you want to smash it? If so, hit it again.</span>")
			smashing = 1
			spawn(20)
				smashing = 0
			return
		user.visible_message("<span class='warning'>\The [user] hits \the [src] with \the [I], and it breaks.[shade.client ? " You hear a terrible scream!" : ""]</span>", "<span class='warning'>You hit \the [src] with \the [I], and it breaks.[shade.client ? " You hear a terrible scream!" : ""]</span>", shade.client ? "You hear a scream." : null)
		set_full(-1)

/obj/item/device/soulstone/attack(var/mob/living/simple_animal/M, var/mob/user)
	if(M == shade)
		to_chat(user, "<span class='notice'>You recapture \the [M].</span>")
		M.forceMove(src)
		return
	if(shade.key || full == 1)
		to_chat(user, "<span class='notice'>\The [src] is already full.</span>")
		return
	if(M.stat == CONSCIOUS || M.health > config.health_threshold_crit)
		to_chat(user, "<span class='notice'>Kill or maim the victim first.</span>")
		return
	for(var/obj/item/W in M)
		M.drop_from_inventory(W)
	//M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their soul captured with \the [src] by [user.name] ([user.ckey])</font>")
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used \the [src] to capture the soul of [M.name] ([M.ckey])</font>")
	//msg_admin_attack("[user.name] ([user.ckey]) used \the [src] to capture the soul of [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	M.dust()

/obj/item/device/soulstone/attack_self(var/mob/user)
	if(!shade.key)
		to_chat(user, "<span class='notice'>You cut your finger and let the blood drip on \the [src].</span>")
		user.pay_for_rune(1)
		var/datum/ghosttrap/cult/shade/S = get_ghost_trap("soul stone")
		S.request_player(shade, "The soul stone shade summon ritual has been performed. ")
		if(shade)
			if(shade.key || shade.client)
				set_full(1)
				return
	else if(!shade.client)
		to_chat(user, "<span class='notice'>\The [shade] in \the [src] is dormant; it slips free from the grasp of the shard.</span>")
		set_full(0) //To prevent grief.
		return
	else if(shade.loc == src)
		to_chat(user, "<span class='notice'>A spirit has taken residence in the [src].</span>")
		var/choice = alert("Would you like to invoke the spirit within?",,"Yes","No",)
		if(choice == "Yes")
			shade.forceMove(get_turf(src))
			to_chat(user, "<span class='notice'>You summon \the [shade].</span>")
		if(choice == "No")
			return
	if(full != 1) //Moved to the end because calling this first would just end the proc each time.
		to_chat(user, "<span class='notice'>This [src] has no life essence.</span>")
		return

/obj/item/device/soulstone/proc/set_full(var/f)
	full = f
	update_icon()

/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = I
		if(!S.shade.client)
			to_chat(user, "<span class='notice'>\The [I] has essence, but no soul. Activate it in your hand to find a soul for it first.</span>")
			return
		if(S.shade.loc != S)
			to_chat(user, "<span class='notice'>Recapture the shade back into \the [I] first.</span>")
			return
		var/construct = alert(user, "Please choose which type of construct you wish to create.",,"Artificer", "Wraith", "Juggernaut")
		var/ctype
		switch(construct)
			if("Artificer")
				ctype = /mob/living/simple_animal/construct/builder
			if("Wraith")
				ctype = /mob/living/simple_animal/construct/wraith
			if("Juggernaut")
				ctype = /mob/living/simple_animal/construct/armoured
		var/mob/living/simple_animal/construct/C = new ctype(get_turf(src))
		C.key = S.shade.key
		//C.cancel_camera()
		if(S.is_evil)
			cult.add_antagonist(C.mind)
		qdel(S)
		qdel(src)
