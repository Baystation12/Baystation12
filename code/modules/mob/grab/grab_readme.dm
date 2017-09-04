/*
There's two parts to the grab system. There's the grab object: /obj/item/grab
and there's the grab datum: /datum/grab.

Each grab datum is a singleton and the system interacts with the rest of the code
base through the grab object. Nothing but the grab object should be reading
from, writing to, or calling the procs of the grab datum. This helps to keep
everything neat and stops undesirable behaviours.

Each type of grab needs a child of the grab datum and a child of the grab
object. The child of each needs to be named with the name of the grab and
the two need the same naming scheme. For example, the main type of grab
used by human is called "normal" as it's the default vanilla grab. The normal
grab has a child of the grab object called /obj/item/grab/normal and it has a child
of the grab datum called /datum/grab/normal.

Each stage of the grab is a child of the grab datum for that grab type. For normal
there's /datum/grab/normal/passive, /datum/grab/normal/aggressive etc. and they
get their general behaviours from their parent /datum/grab/normal.










*/
