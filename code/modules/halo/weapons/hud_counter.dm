
/obj/item/weapon/gun
	var/hud_bullet_row_num = 10 //on the ammo hud, display this amount of bullets per row
	var/hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_4x6.dmi'
	var/hud_bullet_iconstate = "standard"
	var/hud_bullet_usebar = 0

/obj/screen/weapondisplay
	icon = 'code/modules/halo/icons/hud_display/hud_numbers.dmi'
	icon_state = "blank"
	screen_loc = "NORTH,EAST - 2"
	mouse_opacity = 0

	var/mob/living/user
	var/obj/item/weapon/gun/lastgun
	var/max_rounds_row = 10
	var/list/bulletsprites = list()

	//THESE ARE USED ONLY FOR WEAPONS WITH AMMO THAT'S TOO HIGH TO DISPLAY IN SINGULAR AMOUNTS//
	var/image/ammobar
	var/image/basebar
	var/matrix/base_transform
	var/max_ammo

/obj/screen/weapondisplay/New(var/mob/living/l)
	if(!istype(l) || !l.client)
		return INITIALIZE_HINT_QDEL
	user = l

/obj/screen/weapondisplay/proc/clear_bulletsprites(var/amt)
	if(isnull(amt))
		amt = bulletsprites.len
	while(amt > 0)
		amt--
		var/image/to_remove = bulletsprites[bulletsprites.len]
		bulletsprites -= to_remove
		to_remove.loc = null
		user.client.screen -= to_remove

/obj/screen/weapondisplay/proc/update_gun_ref(var/newref)
	if(newref == lastgun)
		return
	lastgun = newref
	clear_bulletsprites()
	if(ammobar)
		ammobar.loc = null
		qdel(ammobar)
		basebar.loc = null
		qdel(basebar)
	var/ammo_max = 0
	if(istype(lastgun,/obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/egun = lastgun
		ammo_max = (egun.power_supply.maxcharge/egun.charge_cost)
	if(istype(lastgun,/obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/pgun = lastgun
		if(pgun.ammo_magazine)
			ammo_max = pgun.ammo_magazine.max_ammo
	if(lastgun.hud_bullet_usebar)
		max_ammo = ammo_max
		ammobar = image('code/modules/halo/icons/hud_display/hud_bullet_bar.dmi',src,"bar")
		basebar = image('code/modules/halo/icons/hud_display/hud_bullet_bar.dmi',src,"basebar")
		base_transform = new(ammobar.transform)
		to_chat(user,basebar)
		to_chat(user,ammobar)
	max_rounds_row = lastgun.hud_bullet_row_num

/obj/screen/weapondisplay/proc/update_ammo()
	set background = 1
	if(lastgun)
		var/ammo_loaded = 0
		if(istype(lastgun,/obj/item/weapon/gun/energy))
			var/obj/item/weapon/gun/energy/egun = lastgun
			ammo_loaded = (egun.power_supply.charge/egun.charge_cost)
		else if(istype(lastgun,/obj/item/weapon/gun/projectile))
			var/obj/item/weapon/gun/projectile/pgun = lastgun
			ammo_loaded = pgun.getAmmo()
		else
			return
		if(!ammobar)
			var/ammo_create = ammo_loaded - bulletsprites.len
			if(ammo_create == 0)
				return
			if(ammo_create < 0)
				clear_bulletsprites(-ammo_create)
				return
			else
				var/icon/bullet_ref_icon = icon(lastgun.hud_bullet_reffile,lastgun.hud_bullet_iconstate)
				var/bullet_xsize = bullet_ref_icon.Width()
				var/bullet_ysize = bullet_ref_icon.Height()
				var/max_pix_x = max_rounds_row * bullet_xsize
				while(ammo_create != 0)
					ammo_create--
					var/image/bulletsprite = image(lastgun.hud_bullet_reffile,src,lastgun.hud_bullet_iconstate)
					bulletsprite.pixel_x = bulletsprites.len * bullet_xsize
					while(bulletsprite.pixel_x >= max_pix_x)
						bulletsprite.pixel_y -= bullet_ysize
						bulletsprite.pixel_x -= max_pix_x
					bulletsprites += bulletsprite
					to_chat(user,bulletsprite)
		else
			var/new_pct = min(1,max(0,ammo_loaded/max_ammo))
			var/matrix/m = new(base_transform)
			m.Scale(new_pct,1)
			ammobar.transform = m

/obj/screen/weapondisplay/Destroy()
	for(var/bullet in bulletsprites)
		qdel(bullet)
	lastgun = null
	if(ammobar)
		qdel(ammobar)
		qdel(basebar)
	if(user && user.client)
		user.client.screen -= src
	. = ..()

/mob/living/carbon/human/Stat()
	. = ..()
	if(client)
		var/obj/screen/weapondisplay/display = locate(/obj/screen/weapondisplay) in client.screen
		if(istype(glasses,/obj/item/clothing/glasses/hud/tactical))
			if(!display)
				display = new(src)
			display.update_ammo()
		else
			if(display)
				display.loc = null
				qdel(display)