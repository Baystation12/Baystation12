### Prerequisites

The server connects to a mysql-compatible server (mysql, mariadb, percona), so you'll need one of those with a database and user/password pair ready.

We use [flyway](https://flywaydb.org/) to manage database migrations. To set up the database, you'll need to [download flyway](https://flywaydb.org/getstarted/download.html).

You'll also need some proficiency with the command line.

---

### Initial setup

In the root project directory, run:

    path/to/flyway migrate -user=USER -password=PASSWORD -url=jdbc:mysql://HOST/DATABASE

Where USER is your mysql username, PASSWORD is your mysql password, HOST is the hostname of the mysql server and DATABASE is the database to use.

---

### Migrating

Use the same command as above. Handy, isn't it?

---

### Using a pre-flyway database

If you're using a database since before we moved to flyway, it's a bit more involved to get migrations working.

In the root project directory, run:

    path/to/flyway baseline -user=USER -password=PASSWORD -url=jdbc:mysql://HOST/DATABASE -baselineVersion=001 -baselineDescription="Initial schema"

From there, you can run migrations as normal.

---

### Configuration file

Instead of putting -user, -password and -url in the command line every time you execute flyway, you can use a config file. Create it somewhere in the root of your project (we're calling it 'db.conf'):

    flyway.url=jdbc:mysql://HOST/DATABASE
    flyway.user=USER
    flyway.password=PASSWORD

Now you can just run `flyway migrate -configFile=db.conf`, and the settings will be loaded from config.
