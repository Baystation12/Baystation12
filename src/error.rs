use std::error::Error;
use std::fmt;
use std::borrow::Cow;

#[derive(Debug)]
enum Cause {
    Inner(Box<Error>),
    Msg(String),
}

#[derive(Debug)]
pub struct FromSqlError {
    cause: Cause,
}

impl FromSqlError {
    pub fn with_msg<'a, T>(t: T) -> FromSqlError where T: Into<Cow<'a, str>> {
        FromSqlError {
            cause: Cause::Msg(t.into().into_owned()),
        }
    }
}

impl fmt::Display for FromSqlError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self.cause {
            Cause::Inner(ref e) => write!(f, "FromSqlError({})", e),
            Cause::Msg(ref s) => write!(f, "FromSqlError({})", s),
        }
    }
}

impl Error for FromSqlError {
    fn source(&self) -> Option<&(dyn Error + 'static)> {
        match self.cause {
            Cause::Inner(ref i) => Some(&**i),
            _ => None,
        }
    }
}

impl From<postgres::Error> for FromSqlError {
    fn from(o: postgres::Error) -> FromSqlError {
        FromSqlError {
            cause: Cause::Inner(Box::new(o)),
        }
    }
}