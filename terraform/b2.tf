data "b2_account_info" "this" {}

# bucket names are global across B2; a new suffix means a new bucket
resource "random_id" "b2_bucket_suffix" {
  byte_length = 4

  lifecycle {
    prevent_destroy = true
  }
}

resource "b2_bucket" "backups" {
  bucket_name = "selfhosted-backups-${random_id.b2_bucket_suffix.hex}"
  bucket_type = "allPrivate"

  default_server_side_encryption {
    mode      = "SSE-B2"
    algorithm = "AES256"
  }

  lifecycle_rules {
    file_name_prefix                                       = ""
    days_from_hiding_to_deleting                           = 30
    days_from_starting_to_canceling_unfinished_large_files = 7
  }

  # prune talos etcd backups older than 30d
  lifecycle_rules {
    file_name_prefix              = "talos-backup/"
    days_from_uploading_to_hiding = 30
    days_from_hiding_to_deleting  = 30
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "b2_application_key" "cnpg" {
  key_name     = "cnpg"
  capabilities = ["listBuckets", "listFiles", "readFiles", "writeFiles"]
  bucket_ids   = [b2_bucket.backups.bucket_id]
  name_prefix  = "cnpg-backups/"
}

resource "b2_application_key" "talos_backup" {
  key_name     = "talos-backup"
  capabilities = ["listBuckets", "listFiles", "readFiles", "writeFiles"]
  bucket_ids   = [b2_bucket.backups.bucket_id]
  name_prefix  = "talos-backup/"
}
