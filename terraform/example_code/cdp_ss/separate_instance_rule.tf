# Server Separate Config sample

resource "nifcloud_separate_instance_rule" "ss1" {
  # The instance name
  instance_id        = [nifcloud_instance.srv1.instance_id, nifcloud_instance.srv2.instance_id]
  # Create Zone
  availability_zone  = "east-14"
  # memo
  description        = "CDP Server Separate Pattern" 
  # Server Separate Name  
  name               = "ss1"
}

resource "nifcloud_separate_instance_rule" "ss2" {
  # The instance name
  instance_id        = [nifcloud_instance.srv2.instance_id, nifcloud_instance.srv3.instance_id]
  # Create Zone
  availability_zone  = "east-14"
  # memo
  description        = "CDP Server Separate Pattern"   
  # Server Separate Name  
  name               = "ss2"
}

resource "nifcloud_separate_instance_rule" "ss3" {
  # The instance name
  instance_id        = [nifcloud_instance.srv1.instance_id, nifcloud_instance.srv3.instance_id]
  # Create Zone
  availability_zone  = "east-14"
  # memo
  description        = "CDP Server Separate Pattern"   
  # Server Separate Name  
  name               = "ss3"
}
