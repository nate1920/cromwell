package cromwell.services.database

/**
  * Cromwell unit tested DBMS. Each DBMS must match a database spun up in test.inc.sh.
  */
sealed trait DatabaseSystem {
  val name: String
  val platform: DatabasePlatform

  override def toString: String = name
}

object DatabaseSystem {
  val All: Seq[DatabaseSystem] = List(
    HsqldbDatabaseSystem,
    MariadbDatabaseSystem,
    MariadbLatestDatabaseSystem,
    MysqlDatabaseSystem,
    MysqlLatestDatabaseSystem,
    PostgresqlDatabaseSystem,
    PostgresqlLatestDatabaseSystem,
  )
}

case object HsqldbDatabaseSystem extends DatabaseSystem {
  override val name: String = "HSQLDB"
  override val platform: HsqldbDatabasePlatform.type = HsqldbDatabasePlatform
}

sealed trait NetworkDatabaseSystem extends DatabaseSystem

case object MariadbDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "MariaDB"
  override val platform: MariadbDatabasePlatform.type = MariadbDatabasePlatform
}

case object MariadbLatestDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "MariaDB (latest)"
  override val platform: MariadbDatabasePlatform.type = MariadbDatabasePlatform
}

case object MysqlDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "MySQL"
  override val platform: MysqlDatabasePlatform.type = MysqlDatabasePlatform
}

case object MysqlLatestDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "MySQL (latest)"
  override val platform: MysqlDatabasePlatform.type = MysqlDatabasePlatform
}

case object PostgresqlDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "PostgreSQL"
  override val platform: PostgresqlDatabasePlatform.type = PostgresqlDatabasePlatform
}

case object PostgresqlLatestDatabaseSystem extends NetworkDatabaseSystem {
  override val name: String = "PostgreSQL (latest)"
  override val platform: PostgresqlDatabasePlatform.type = PostgresqlDatabasePlatform
}
