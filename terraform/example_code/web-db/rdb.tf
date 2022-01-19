# RDB sample config
resource "nifcloud_db_instance" "db001" {
  # Base Document https://pfs.nifcloud.com/api/rdb/CreateDBInstance.htm
  # -- Basic config --
  #1:Monthly
  #2:Payper
  accounting_type                = "2"
  availability_zone              = "jp-east-41"
  # Database Instance Name
  # See "DBInstanceIdentifier" specifiction
  identifier                     = "db001"
  # Database Instance Size
  # See "DBInstanceClass" specifiction
  instance_class                 = "db.large8"
  # Database Engine
  # See "Engine" specifiction
  engine                         = "MySQL"
  # Database Engine Version
  # See "EngineVersion" specifiction
  engine_version                 = "5.7.15"
  # --- Main Network Config ---
  # Database waiting port
  port                           = 3306
  # Connect PriveteLAN ID
  network_id                     = nifcloud_private_lan.Private01.id
  # Internal LoadBalancer VIP
  virtual_private_address        = "198.51.100.110/24"
  # Master Instance IP
  master_private_address         = "198.51.100.111/24"
  # Firewall
  db_security_group_name         = nifcloud_db_security_group.dbfw.id
  # --- Database Setting ---
  # Database name
  db_name                        = "db001"
  # Database master user name
  # See "MasterUsername" specifiction
  username                       = "username"
  # master user password
  # See "MasterUserPassword" specifiction
  password                       = "barbarbarupd"
  # db parameter
  parameter_group_name           = nifcloud_db_parameter_group.db001param.id
  # Database Disk Type
  # 0:First Disk(HDD)
  # 1:Flash Disk
  # See "NiftyStorageType" specifiction
  storage_type                   = 0
  # Database Disk Size
  # See "AllocatedStorage" specifiction
  allocated_storage              = 50
  # Using Global Network.Inherited to the replica
  publicly_accessible            = false
  # -- Bakcup Config --
  # Backup retention
  # See "BackupRetentionPeriod" specifiction
  backup_retention_period        = 2
  # Backup time range.Set by UTC Time
  # See "PreferredBackupWindow" specifiction
  backup_window                  =  "18:00-18:30" # 03:00-03:30(JCT)
  # -- Maitenace Config --
  # Maitenance Time Range.Set by UTC Time
  # See "PreferredMaintenanceWindow" specifiction
  maintenance_window             = "sun:19:00-sun:19:30" # mon:04:00-04:30(JCT)
  # -- Redundant Config --
  # Enable Redundant?
  multi_az                       = true
  # Redundant Type
  # 0:Prioritize Data protection
  # 1:Prioritize Performance(MySQL Only)
  multi_az_type                  = 1
  # name of read replica instance name
  # Only Use multi_az_type is 1
  # See "NiftyReadReplicaDBInstanceIdentifie" specifiction
  # DO NOT SET when multi_az_type is 0,
  # destory command will not be possible
  read_replica_identifier        = "db001-read"
  # Secondry DB IP
  # if multi_az_type is 0
  #slave_private_address          = "198.51.100.112/24"
  ## if only multi_az_type is 1
  read_replica_private_address   = "198.51.100.112/24"
  # --- Database Option Parameter ---
  # if engine parameter is MySQL can set
  # save the custom binlog.
  custom_binlog_retention_period = true
  # set the original binlog retention day
  binlog_retention_period        = 2
  # apply immediate for change parameter at apply.
  # if this parameter false. config apply in maitenance period.
  # See also "ApplyImmediately" in 
  # https://pfs.nifcloud.com/api/rdb/ModifyDBInstance.htm
  apply_immediately              = true
  # --- Terrfrom Parameter ---
  # bakcup in destory
  skip_final_snapshot            = false
  # this parameter only need if skip_final_snapshot is false.
  # this parameter is only used during the destory phate
  # as a snapshot name
  final_snapshot_identifier      = "db001snap"
}

resource "nifcloud_db_parameter_group" "db001param" {
  # Base Document https://pfs.nifcloud.com/api/rdb/CreateDBParameterGroup.htm
  # Config Name
  name        = "db001param"
  # Database Parameter Family name
  # See also "DBParameterGroupFamily" specifiction
  family      = "mysql5.7"
  description = "memo"

  parameter {
      name  = "character_set_server"
      value = "utf8"
  }

  parameter {
      name  = "character_set_client"
      value = "utf8"
  }

  parameter {
      name         = "character_set_results"
      value        = "utf8"
      apply_method = "pending-reboot"
  }
}

resource "nifcloud_db_security_group" "dbfw" {
  # Group Name
  group_name        = "dbfw01"
  description       = "memo"
  availability_zone = "jp-east-41"

  # Accept Rule
  # by CIDR
  rule {
    cidr_ip = nifcloud_private_lan.Private01.cidr_block
  }
  # by Firewall Group
  rule {
    security_group_name = nifcloud_security_group.webfw.group_name
  }
}
