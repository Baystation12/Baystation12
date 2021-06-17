#define ATOM_IS_TEMPERATURE_SENSITIVE(A) (A && !QDELETED(A) && !(A.atom_flags & ATOM_FLAG_NO_TEMP_CHANGE))
#define ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD 5
#define ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT 0.25

#define ADJUST_ATOM_TEMPERATURE(_atom, _temp) \
	_atom.temperature = _temp; \
	if(_atom.reagents) { \
		HANDLE_REACTIONS(_atom.reagents); \
	} \
	QUEUE_TEMPERATURE_ATOMS(_atom);

#define QUEUE_TEMPERATURE_ATOMS(_atoms) \
	if(islist(_atoms)) { \
		for(var/thing in _atoms) { \
			var/atom/A = thing; \
			if(ATOM_IS_TEMPERATURE_SENSITIVE(A)) { \
				SStemperature.processing[A] = TRUE; \
			} \
		} \
	} else if(ATOM_IS_TEMPERATURE_SENSITIVE(_atoms)) { \
		SStemperature.processing[_atoms] = TRUE; \
	}
