
/obj/structure/barricade/attack_generic(var/mob/user, var/damage, var/attacktext)
	src.health -= damage
	//user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	playsound(src.loc, 'sound/weapons/bite.ogg', 50, 0, 0)
	if(src.health <= 0)
		visible_message("<span class='danger'>[src] is smashed apart by [user]!</span>")
		dismantle()
		qdel(src)
	else
		visible_message("<span class='danger'>[user] [attacktext] the [src]!</span>")

/obj/structure/barricade/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage/10
	playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
	if (src.health <= 0)
		dismantle()
		qdel(src)
