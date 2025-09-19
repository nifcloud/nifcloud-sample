# RDB sample config
resource "nifcloud_db_instance" "db001" {
  # Base Document https://docs.nifcloud.com/rdb/api/CreateDBInstance.htm
  # -- Basic config --
  #1:Monthly
  #2:Pay-per
  accounting_type                = "2"
  availability_zone              = "east-11"
  # Database Instance Name
  # See "DBInstanceIdentifier" specification
  identifier                     = "db001"
  # Database Instance Size
  # See "DBInstanceClass" specification
  instance_class                 = "db.e-large"
  # Database Engine
  # See "Engine" specification
  engine                         = "MySQL"
  # Database Engine Version
  # See "EngineVersion" specification
  engine_version                 = "8.0.34"
  # --- Main Network Config ---
  # Database waiting port
  port                           = 3306
  # Connect PriveteLAN ID
  network_id                     = nifcloud_private_lan.PrivateLan01.id
  # Internal LoadBalancer VIP
  virtual_private_address        = "192.0.2.110/24"
  # Master Instance IP
  master_private_address         = "192.0.2.111/24"
  # Slave Instance IP
  slave_private_address          = "192.0.2.112/24"
  # Firewall
  db_security_group_name         = nifcloud_db_security_group.dbfw.id
  # --- Database Setting ---
  # Database name
  db_name                        = "db001"
  # Database master user name
  # See "MasterUsername" specification
  username                       = "username"
  # master user password
  # See "MasterUserPassword" specification
  password                       = "barbarbarupd"
  # db parameter
  parameter_group_name           = nifcloud_db_parameter_group.db001param.id
  # Database Disk Type
  # 0:High-Speed Storage
  # 1:Flash Drive
  # 2:Standard Flash Storage
  # 3:High-Speed Flash Storage
  # See "NiftyStorageType" specification
  storage_type                   = 3
  # Database Disk Size
  # See "AllocatedStorage" specification
  allocated_storage              = 50
  # Using Global Network.Inherited to the replica
  publicly_accessible            = false
  # -- Bakcup Config --
  # Backup retention
  # See "BackupRetentionPeriod" specification
  backup_retention_period        = 0
  # Backup time range.Set by UTC Time
  # See "PreferredBackupWindow" specification
  backup_window                  =  "18:00-18:30" # 03:00-03:30(JCT)
  # -- Maintenance Config --
  # Maintenance Time Range.Set by UTC Time
  # See "PreferredMaintenanceWindow" specification
  maintenance_window             = "sun:19:00-sun:19:30" # mon:04:00-04:30(JCT)
  # -- Redundant Config --
  # Enable Redundant?
  multi_az                       = true
  # Redundant Type
  # 0:Prioritize Data protection
  # 1:Prioritize Performance(MySQL Only)
  custom_binlog_retention_period = false
  # set the original binlog retention day
#  binlog_retention_period        = 2
  # apply immediate for change parameter at apply.
  # if this parameter false. config apply in maitenance period.
  # See also "ApplyImmediately" in 
  # https://docs.nifcloud.com/rdb/api/ModifyDBInstance.htm
  apply_immediately              = true
  # --- Terrfrom Parameter ---
  # backcup in destroy
  skip_final_snapshot            = false
  # this parameter only need if skip_final_snapshot is false.
  # this parameter is only used during the destory phate
  # as a snapshot name
  final_snapshot_identifier      = "db001snap"
}

resource "nifcloud_db_parameter_group" "db001param" {
  # Base Document https://docs.nifcloud.com/rdb/api/CreateDBParameterGroup.htm
  # Config Name
  name        = "db001param"
  # Database Parameter Family name
  # See also "DBParameterGroupFamily" specifiction
  family      = "mysql8.0"
  description = "cdp_rdb_redundancy"

  parameter {
      name  = "character_set_server"
      value = "utf8mb4"
  }

  parameter {
      name  = "character_set_client"
      value = "utf8mb4"
  }

  parameter {
      name         = "character_set_results"
      value        = "utf8mb4"
      apply_method = "pending-reboot"
  }
}

resource "nifcloud_db_security_group" "dbfw" {
  # Group Name
  group_name        = "dbfw01"
  description       = "cdp_rdb_redundancy"
  availability_zone = "east-11"

  # Accept Rule
  # by CIDR
  rule {
    cidr_ip = nifcloud_private_lan.PrivateLan01.cidr_block
  }
  # by Firewall Group
  rule {
    security_group_name = nifcloud_security_group.websrvfw.group_name
  }
}
