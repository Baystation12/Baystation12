use std::cell::RefCell;
use std::borrow::Cow;
use std::error::Error;

use postgres::{Connection, TlsMode, types::{Type, ToSql}, rows::Row};
use serde_json::Value;
use chrono::{NaiveDate, NaiveTime, NaiveDateTime};

use crate::error::FromSqlError;

thread_local! {
    static CONNECTION: RefCell<Option<Connection>> = RefCell::new(None);
    static LASTERR: RefCell<String> = RefCell::new(String::default());
}

fn set_err<'a, I>(msg: I) where I: Into<Cow<'a, str>> {
    let s: String = msg.into().into_owned();
    LASTERR.with(|cell| cell.replace(s));
}

byond_fn! { is_connected() {
    CONNECTION.with(|cell| match *cell.borrow() {
        Some(_) => Some("true"),
        None => None
    })
} }

byond_fn! { connect(uri) {
    let conn = match Connection::connect(uri.as_ref(), TlsMode::None) {
        Ok(c) => c,
        Err(e) => {
            set_err(e.description());
            return None;
        }
    };
    CONNECTION.with(|cell| cell.replace(Some(conn)));
    Some("ok")
} }

fn convert_bool(v: Option<bool>) -> Value {
    match v {
        Some(b) => Value::Bool(b),
        None => Value::Null,
    }
}

fn convert_number<N>(v: Option<N>) -> Value where N: Into<serde_json::Number> {
    match v {
        Some(n) => Value::Number(n.into()),
        None => Value::Null,
    }
}

fn convert_float(v: Option<f64>) -> Value {
    match v {
        Some(n) => Value::Number(serde_json::Number::from_f64(n).unwrap_or_else(|| 0.into())),
        None => Value::Null,
    }
}

fn convert_string(v: Option<String>) -> Value {
    match v {
        Some(s) => Value::String(s),
        None => Value::Null,
    }
}

fn convert_json(v: Option<Value>) -> Value {
    match v {
        Some(j) => j,
        None => Value::Null,
    }
}

fn convert_datetime(v: Option<NaiveDateTime>) -> Value {
    match v {
        Some(d) => Value::String(d.format("%Y-%m-%d %H:%M:%S").to_string()),
        None => Value::Null,
    }
}

fn convert_time(v: Option<NaiveDate>) -> Value {
    match v {
        Some(d) => Value::String(d.format("%Y-%m-%d").to_string()),
        None => Value::Null,
    }
}

fn convert_date(v: Option<NaiveTime>) -> Value {
    match v {
        Some(d) => Value::String(d.format("%H:%M:%S").to_string()),
        None => Value::Null,
    }
}

fn get_row_val(ty: &Type, row: &Row, n: usize) -> Result<Value, FromSqlError> {
    use postgres::types::*;
    Ok(match *ty {
        BOOL => convert_bool(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        CHAR => convert_number::<i8>(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        INT2 => convert_number::<i16>(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        INT4 => convert_number::<i32>(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        INT8 => convert_number::<i64>(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        OID => convert_number::<u32>(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        FLOAT4 => convert_float(row.get_opt::<usize, Option<f32>>(n).ok_or(FromSqlError::with_msg("got NULL"))??.map(|x| x as f64)),
        FLOAT8 => convert_float(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        VARCHAR | TEXT | BPCHAR | NAME | UNKNOWN => convert_string(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        JSON | JSONB => convert_json(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        TIMESTAMP => convert_datetime(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        TIME => convert_time(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        DATE => convert_date(row.get_opt(n).ok_or(FromSqlError::with_msg("got NULL"))??),
        _ => return Err(FromSqlError::with_msg(format!("unimplemented type {}", ty.name())))
    })
}

byond_fn! { query(args...) {
    if args.len() < 1 {
        set_err("no arguments provided to query");
        return None
    }

    let c: Result<String, Box<Error>> = CONNECTION.with(|cell| {
        let z = cell.borrow();
        let c = z.as_ref().ok_or("not connected")?;
        let arg_refs: Vec<_> = args[1..].iter().map(|x| x as &dyn ToSql).collect();
        let rows = c.query(args[0].as_ref(), &arg_refs)?;
        let mut res = Vec::new();
        let col_types: Vec<_> = rows.columns().iter().map(|c| c.type_()).cloned().collect();
        for row in rows.into_iter() {
            let mut rowi = Vec::new();
            for (i, ct) in col_types.iter().enumerate() {
                rowi.push(get_row_val(ct, &row, i)?);
            }
            res.push(rowi);
        }
        Ok(serde_json::to_string(&res)?)
    });
    match c {
        Ok(s) => Some(s),
        Err(e) => { set_err(e.to_string()); None }
    }
} }

byond_fn! { execute(args...) {
    if args.len() < 1 {
        set_err("no arguments provided to execute");
        return None
    }

    let c: Result<String, Box<Error>> = CONNECTION.with(|cell| {
        let z = cell.borrow();
        let c = z.as_ref().ok_or("not connected")?;
        let arg_refs: Vec<_> = args[1..].iter().map(|x| x as &dyn ToSql).collect();
        let rowct = c.execute(args[0].as_ref(), &arg_refs)?;
        Ok(rowct.to_string())
    });

    match c {
        Ok(s) => Some(s),
        Err(e) => { set_err(e.to_string()); None } 
    }
} }

byond_fn! { last_err() {
    let mut err = String::new();
    LASTERR.with(|cell| err.clone_from(&*cell.borrow()));
    Some(err)
} }

byond_fn! { shutdown() {
    CONNECTION.with(|cell| cell.replace(None));
    Some("ok")
} }
