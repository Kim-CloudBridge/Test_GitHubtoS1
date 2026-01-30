region     = "eu-west-2"
client_id  = "0000"
env_suffix = "t"
tier       = "tier3"
env_domain = "TEST"
#MDB config
# mdb_instance_type           = "r5.2xlarge"
mdb_ami                     = "ami-0f4ec44c2a87820a2"
mdb_instances_count         = 1
mdb_number_of_secondary_ips = 2
#RDB config
# rdb_instance_type           = "r5.2xlarge"
rdb_ami                     = "ami-0f4ec44c2a87820a2"
rdb_instances_count         = 1
rdb_number_of_secondary_ips = 2
assume_role_account_ids = [471112584094, 339713075950]