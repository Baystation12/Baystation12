
/obj/structure/tree_indestructable
	name = "tree"
	icon = 'code/modules/halo/icons/doodads/trees.dmi'
	icon_state = "tree1"
	anchored = 1

/obj/structure/tree_indestructable/New()
	..()
	icon_state = "tree[rand(1,4)]"

/obj/structure/tree_indestructable/ex_act()
	return
