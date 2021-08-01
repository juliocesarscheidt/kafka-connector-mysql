USE kafka_database;

CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT NOW(),
  updated_at DATETIME NULL,
  deleted_at DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
);

-- SELECT CAST(id AS UNSIGNED) AS id, name, email, password, created_at, updated_at, deleted_at FROM kafka_database.users;

CREATE USER '${DEBEZIUM_USER}'@'%' IDENTIFIED BY '${DEBEZIUM_PASS}';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO '${DEBEZIUM_USER}'@'%';

SELECT user, host from mysql.user;

FLUSH PRIVILEGES;

SHOW GLOBAL VARIABLES LIKE 'server_id';

SHOW GLOBAL VARIABLES LIKE 'log_bin';
SHOW GLOBAL VARIABLES LIKE 'binlog_format';
SHOW GLOBAL VARIABLES LIKE 'binlog_row_image';

-- OFF <-> OFF_PERMISSIVE <-> ON_PERMISSIVE <-> ON
SET GLOBAL enforce_gtid_consistency=ON;
SHOW GLOBAL VARIABLES LIKE 'enforce_gtid_consistency';

SET GLOBAL gtid_mode=OFF;
SET GLOBAL gtid_mode=OFF_PERMISSIVE;
SET GLOBAL gtid_mode=ON_PERMISSIVE;
SET GLOBAL gtid_mode=ON;
SHOW GLOBAL VARIABLES LIKE 'gtid_mode';

SHOW GLOBAL VARIABLES LIKE 'interactive_timeout';
SHOW GLOBAL VARIABLES LIKE 'wait_timeout';

SET GLOBAL binlog_rows_query_log_events=ON;
SHOW GLOBAL VARIABLES LIKE 'binlog_rows_query_log_events';

SHOW MASTER STATUS;
