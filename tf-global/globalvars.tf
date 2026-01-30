locals {
  global = {
    aws_landing_zone = {
      network                  = "129360778929"
      hms_shared_services      = "214889837512"
      hms_management_utilities = "211031537472"
    }

    naming_convention = {
      product = "hms"
      regions = {
        eu-west-2 = "01"
        eu-west-1 = "02"
      }
      SHAREDDB                 = "shared-db"
      SHAREDWS                 = "shared-ws"
      MANAGE-INSTANCES         = "manage-instances"
      LAMBDA                   = "lambda"
      APPSTREAM                = "appstream"
      S3                       = "s3"
      SAAS                     = "saas-portal"
      FLEET                    = "fleet"
      STACK                    = "stack"
      APIGATEWAY               = "api-gateway"
      APP                      = "app"
      DMZ                      = "dmz"
      SPB                      = "spb"
      SPV                      = "spv"
      VPC                      = "vpc"
      GLOBAL_SERVICE           = "x"
      ROUTE_TABLE              = "rtb"
      ACL                      = "acl"
      ROUTE_TABLE              = "rtb"
      INTERNET_GATEWAY         = "igw"
      SECURITY_GROUP           = "sgp"
      TARGET_GROUP             = "tgp"
      PUBLIC_SERVICE           = "publicsvc"
      NGINX                    = "nginx"
      ALB                      = "alb"
      NLB                      = "nlb"
      HALO                     = "halo"
      AURA                     = "aura"
      CORE                     = "core"
      MDB                      = "mdb"
      RDB                      = "rdb"
      JMS                      = "jms"
      API                      = "api"
      HAZELCAST                = "hazelcast"
      SVC_CORP_ACCESS          = "svc-corp-access"
      EC2                      = "ec2"
      AUTOSCALING_GROUP        = "asg"
      LAUNCH_CONFIGURATION     = "lc"
      SSM                      = "ssm"
      ROLE                     = "role"
      INSTANCE_PROFILE         = "inspro"
      WEB_SERVICE              = "ws"
      TGW_ATT                  = "tgw-att"
      WEB_APPLICATION_FIREWALL = "waf"
      FSX                      = "fsx"
      POLICY                   = "policy"
      FSXN                     = "fsxn"
      SVM                      = "svm"
      VOLUME                   = "vol"
      CICD                     = "cicd"
      S3                       = "s3"
      VPCE                     = "endpoint"
      JENKINS                  = "jnkns"
      KMS                      = "kms"
    }

    site_networks = {
      emea = [
        "10.240.0.0/16",
        "10.230.0.0/16"
      ]
      apac               = []
      ap-southeast-1     = ""
      ap-southeast-1-dmz = ""
      eu-west-2          = "10.210.0.0/16"
      eu-west-2_customer_range = [
        "10.210.40.0/21",
        "10.210.48.0/20",
        "10.210.64.0/19",
        "10.210.96.0/22",
        "10.210.140.0/22",
        "10.210.144.0/20",
        "10.210.160.0/19",
        "10.210.192.0/21",
      ]
      eu-west-2-dmz = "172.210.0.0/16"
      eu-dc = [
        "83.244.209.34/32",
        "83.244.209.35/32",
        "83.244.209.36/32",
        "83.244.209.37/32",
        "83.244.209.38/32",
        "83.244.209.39/32",
        "83.244.209.40/32",
        "83.244.209.41/32",
        "83.244.209.42/32",
        "83.244.209.43/32",
        "83.244.209.44/32",
        "83.244.209.45/32",
        "83.244.209.46/32",
        "83.244.209.47/32",
        "83.244.209.48/32",
        "83.244.209.49/32",
        "83.244.209.50/32",
        "83.244.209.51/32",
        "83.244.209.52/32",
        "83.244.209.53/32",
        "83.244.209.54/32",
        "83.244.209.55/32",
        "83.244.209.56/32",
        "83.244.209.57/32",
        "83.244.209.58/32",
        "83.244.209.59/32",
        "83.244.209.60/32",
        "83.244.209.61/32",
        "83.244.209.62/32"
      ]
      eu-dns = [
        "10.240.101.100/32",
        "10.230.101.100/32"
      ]
    }

    lendscape_landing_zone_networks = {
      eu-west-2 = {
        shared_test_domain_dmz = "172.210.100.0/25"
        shared_test_domain_ws = "10.210.100.0/24"
        shared_test_domain_db = "10.210.104.0/24"
        east_west_firewall = "10.210.120.0/22"
      }
    }

    WAN_CONFIG = {
      eu-west-2 = {
        DX_GATEWAY_ASN = "64513"
        CONNS = {
          primary = {
            name             = "CLE169070_Pri"
            amazon_address   = "100.100.0.10/30",
            customer_address = "100.100.0.9/30"
            bgp_asn          = "25180"
            bgp_auth_key     = "Mgdh4JMCm4"
            vlan             = "311"
          },
          secondary = {
            name             = "CLE169070_Sec"
            amazon_address   = "100.100.0.14/30",
            customer_address = "100.100.0.13/30"
            bgp_asn          = "25180"
            bgp_auth_key     = "Mgdh4JMCm4"
            vlan             = "311"
          }
        }
      }
    }

    WAF_REGIONAL_SCOPE   = "REGIONAL"
    WAF_CLOUDFRONT_SCOPE = "CLOUDFRONT"

    tagging_convention = {
      service_tag = {
        OPENACCOUNTING  = "OA"
        LENDSCAPE       = "LS"
        ASSETFINANCE    = "AF"
        SOLARWINDS      = "SW"
        GOANYWHERE      = "GA"
        SKYBOT          = "SB"
        NGINX           = "NX"
        ELASTIC         = "EL"
        FORTIGATE       = "FG"
        ACTIVEDIRECTORY = "AD"
        SHAREDSERVICES  = "SS"
        CICD            = "CICD"
      },
      component_tag = {
        OPENACCOUNTINGEXTERNAL = "EXT"
        OPENACCOUNTINGCENTRAL  = "CEN"
        OPENACCOUNTINGENGINE   = "EMG"
        OPENACCOUNTINGDATABASE = "DB"

        LSCOREAPPSERVER         = "CORE"
        LSEXTERNALWEBSERVERHALO = "WEB-HALO"
        LSINTERNALWEBSERVERAURA = "WEB-AURA"
        LSINTERNALWEBSERVERDMS  = "WEN-DMS"
        LSMAINDB                = "MDB"
        LSREPOTINGDB            = "RDB"
        LSDMSDB                 = "DMSDB"

        GOANYWHERECORE    = "CORE"
        GOANYWHEREGATEWAY = "GATEWAY"

        SOLARWINDSCORE = "CORE"
      },
      bia_risk = {
        CRITICAL = "BIA-C"
        HIGH     = "BIA-H"
        MEDIUM   = "BIA-M"
        LOW      = "BIA-L"

      },
      cia_risk = {
        CRITICAL = "CIA-C"
        HIGH     = "CIA-H"
        MEDIUM   = "CIA-M"
        LOW      = "CIA-L"

      },
      data_classification = {
        PUBLIC       = "Public"
        PROPRIETARY  = "Propretary"
        RESTRICTED   = "Restricted"
        CONFIDENTIAL = "Confidential"
      }

      map_migrate = {
        map-migrated = "migTH2XDLWMO9"
      }
    }

    tags = {}
  }
}

output "global" {
  value = local.global
}