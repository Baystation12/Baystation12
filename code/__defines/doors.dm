// Value for `/obj/machinery/door/var/operating`
/// Door is not currently doing anything.
#define DOOR_OPERATING_NO 0
/// Door is opening or closing.
#define DOOR_OPERATING_YES 1
/// Door has been emagged or is otherwise non functional.
#define DOOR_OPERATING_BROKEN -1


// Flags for `/obj/machinery/door/airlock/var/paintable`
/// The main airlock body is paintable.
#define AIRLOCK_PAINTABLE_MAIN FLAG(0)
/// The stripe decal is paintable.
#define AIRLOCK_PAINTABLE_STRIPE FLAG(1)
/// Other detailing is paintable.
#define AIRLOCK_PAINTABLE_DETAIL FLAG(2)
/// The window is paintable.
#define AIRLOCK_PAINTABLE_WINDOW FLAG(3)
