//from infinity //PRX
/obj/structure/changeling_cocoon
	name = "meaty cocoon"
	desc = "A gross looking cocoon, made of some sort of bilogical mass..."
	icon = 'proxima/icons/obj/changeling.dmi'
	icon_state = "cocoon_progress"
	w_class = ITEM_SIZE_NO_CONTAINER
	layer = ABOVE_WINDOW_LAYER
	density = TRUE
	var/mob/living/carbon/human/victim = null
	var/birth_time = 120 //seconds
	var/idle_time = 0
	var/idle_time_max = 60 //seconds
	var/progress = 0 //in seconds
	var/last_sound_time
	var/health
	var/max_health = 100

/obj/structure/changeling_cocoon/Initialize()
	. = ..()
	last_sound_time = world.time
	health = max_health
	START_PROCESSING(SSobj, src)

/obj/structure/changeling_cocoon/Process()
	if(!victim?.client)
		idle_time++
		if(idle_time >= idle_time_max)
			if(victim)
				victim.Drain()
			qdel(src)
		return
	if(health < max_health)
		if(prob(4))
			visible_message(SPAN_WARNING("Раны на \icon[src] [src] медленно затягиваются."))
		health++
	progress++
	if(birth_time / 5 <= progress && !(progress%10))
		to_chat(victim, SPAN_LING("Вы чувствуете слабость, кажется время пришло..."))
	if(progress >= birth_time)
		birth()
	on_update_icon()
	if(world.time >= last_sound_time + 20 SECONDS)
		last_sound_time = world.time
		playsound(get_turf(src), 'proxima/sound/effects/lingextends.ogg', 15, 1, -4.5)
		visible_message(pick(
			SPAN_WARNING("\icon[src] [src] учащённо пульсирует..."),
			SPAN_WARNING("\icon[src] [src] внутри что-то двигается...")))

/obj/structure/changeling_cocoon/Destroy()
	drop_victim()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/changeling_cocoon/on_update_icon()
	if(progress <= birth_time)
		icon_state = "cocoon_progress"

//	switch(health) //todo

/obj/structure/changeling_cocoon/attackby(obj/item/I, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(I, /obj/item/device/scanner))
		var/obj/item/device/scanner/scanner = I
		scanner.scan(victim)
		return
	if(user.a_intent == I_HURT)
		user.do_attack_animation(src)
		var/damage = I.force
		if(I.damtype == INJURY_TYPE_BURN)
			damage *= 2
		playsound(get_turf(src), I.hitsound, 15, 1)
		damage_health(damage)
		user.visible_message(SPAN_WARNING("[user] [pick(I.attack_verb)]s [src]!"), SPAN_WARNING("You [pick(I.attack_verb)] [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] тыкает [src] [I]."), SPAN_WARNING("Вы тыкаете в \icon[src] [src] \icon[I] [I]."))

/obj/structure/changeling_cocoon/attack_generic(var/mob/user, var/damage, var/attack_verb)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_DANGER("\The [user] [attack_verb] \the [src]!"))
	attack_animation(user)
	damage_health(damage)

/obj/structure/changeling_cocoon/attack_hand(var/mob/M)
	if(M.a_intent == I_HURT)
		if(M in contents)
			M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 2) //double cooldown
			M.visible_message(SPAN_DANGER("Что-то вырывается изнутри [src]!"), SPAN_WARNING("Мы пытаемя вырваться из [src]!"))
			playsound(get_turf(src), 'sound/weapons/bite.ogg', 20, 1)
			damage_health(20) //todo: update with species attack state, bite one (or not?)
		else
			M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			M.do_attack_animation(src)
			M.visible_message(SPAN_WARNING("[M] пинает [src]!"), SPAN_WARNING("Вы пинаете [src]!"))
			playsound(get_turf(src), pick(('sound/weapons/genhit1.ogg'), ('sound/weapons/genhit2.ogg'), pick('sound/weapons/genhit3.ogg')), 50, 1)
			damage_health(3) //todo: update with species attack states
	else
		M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(M in contents)
			to_chat(M, "Вы касаетесь внутренней оболочки [src]. Оно кажется склизким и тёплым, через неё можно увидеть смутные образы того что вокруг.")
		else
			M.visible_message(SPAN_WARNING("[M] трогает [src]..."), "Вы касаетесь [src]. Оно кажется склизким и тёплым.")

/obj/structure/changeling_cocoon/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == INJURY_TYPE_BRUISE || Proj.damage_type == INJURY_TYPE_BURN))
		return
	switch(Proj.damage_type)
		if(INJURY_TYPE_BRUISE) visible_message(SPAN_WARNING("[src] разрывается!"))
		if(INJURY_TYPE_BURN) visible_message(SPAN_WARNING("[src] тает на глазах!"))
	damage_health(Proj.damage)
	..()

/obj/structure/changeling_cocoon/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			damage_health(90)
		if(3)
			damage_health(40)

/* todo
/obj/structure/changeling_cocoon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return
*/

/obj/structure/changeling_cocoon/damage_health(var/amount)
	health -= amount
	if(health < max_health / 4 && victim)
		visible_message(SPAN_WARNING("\icon[src] [src] разрывается и странная слизь вытекает из него!"))
		new /obj/effect/decal/cleanable/filth(src)
		drop_victim()
		icon_state = "cocoon_opened"
	if(health < 0)
		visible_message(SPAN_WARNING("\icon[src] [src] разрывается!"))
		qdel(src)

/obj/structure/changeling_cocoon/examine(mob/user)
	. = ..()
	if(Adjacent(user) && victim)
		to_chat(user, SPAN_DANGER("[src] слабо пульсирует."))
/*
/obj/structure/changeling_cocoon/attack_ghost(var/mob/observer/ghost/user)
	if(convert(user))
		spawn(1 SECOND)
			if(user) qdel(user) // Remove the keyless ghost if it exists.
*/
/obj/structure/changeling_cocoon/proc/drop_victim()
	if(victim)
		visible_message(SPAN_DANGER("[victim] падает на пол из [src]!"))
		victim.dropInto(loc)
		victim = null

/obj/structure/changeling_cocoon/proc/absorb_victim(mob/nvictim)
	nvictim.forceMove(src)
	victim = nvictim
	background()
	to_chat(victim, SPAN_DANGER("Вас окутывает странная тёплая жидкость, ваше сознание угасает..."))

/obj/structure/changeling_cocoon/proc/background()
	if(!victim?.client)
		return
	to_chat(victim, SPAN_LING("\"Кокон изменяет тело и сознание.<br>\
	Скорее всего, тело умрет до вылупления. Но затем, <i>мы</i> возродимся.<br>\
	Мы будем частью общности - одним из сородичей, что будем работать на её благо и ставить её интересы \
	выше собственных, в том числе и жизни. Мы должны взять под контроль корабль, поглотив его экипаж и превратив \
	этим в себе подобных. Пока экипаж не станет слишком малочисленен и слаб, чтобы можно было охотиться без опаски \
	- нам следует осторожность.<br>\
	Если наш кокон никто не потревожит, то вскоро <i>мы</i> проснемся и прогрызете себе путь на свободу, включившись в охоту. \
	Наше тело требует новые геномы, чтобы жить и развиваться. Не стоит поглощать или убивать сородичей \
	- мы все практически родственники.<br>\
	Сегодня экипаж станет нашим ужином. Удачной охоты.\""))

/*
Revive in the next proc causes runtimes like
Runtime in unsorted.dm, line 1116: GC: -- [0x20006bc] | /obj/item/organ/external/foot was unable to be GC'd --
x7
I don't know how to fix it, tried two days, sorry.
*/

/obj/structure/changeling_cocoon/proc/birth()
	if(!victim.client)
		return
	victim.revive()
	addtimer(CALLBACK(src, .proc/add_changeling), 4 SECONDS)
	addtimer(CALLBACK(src, .proc/prepare_changeling), 7 SECONDS)

	STOP_PROCESSING(SSobj, src)

/obj/structure/changeling_cocoon/proc/add_changeling(datum/mind/victimmind = victim?.mind)
	if(victimmind)
		GLOB.changelings.add_antagonist(victimmind, 1)

/obj/structure/changeling_cocoon/proc/prepare_changeling(mob/living/carbon/human/v = victim)
	if(v?.mind)
		if(v.mind.changeling) //just to don't fuck up with runtimes further
			v.mind.changeling.chem_storage = 30
			v.mind.changeling.chem_charges = 30
			v.mind.changeling.geneticpoints = 5
			to_chat(victim, SPAN_LING(FONT_LARGE("Мы чувствуем себя по иному... Кажется пора покинуть наше временное пристанище...")))

/*
/obj/structure/changeling_cocoon/proc/convert(mob/user)
	if(!victim)
		to_chat(user, SPAN_WARNING("Превращение уже завершилось."))
		return
	if(jobban_isbanned(user, MODE_CHANGELING))
		to_chat(user, SPAN_WARNING("У вас имеется бан на роль генокрадов. Вы не можете играть за них."))
		return
	if(src.victim.client)
		to_chat(user, SPAN_WARNING("Кто-то уже занял это тело до Вас."))
		return
	var/confirm = alert(user, "Вы хотите стать новым генокрадом?", "Новый генокрад", "Нет", "Да")
	if(!user || !src || confirm != "Да")
		return
	victim.ckey = user.ckey
	background()
	to_chat(victim, SPAN_DANGER("Не покидайте тело и игру, чтобы процесс превращения продолжался и другие игроки не заняли его."))
	return 1
*/
