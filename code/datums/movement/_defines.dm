#define IS_SELF(w) !IS_NOT_SELF(w)
#define IS_NOT_SELF(w) (w && w != host)
