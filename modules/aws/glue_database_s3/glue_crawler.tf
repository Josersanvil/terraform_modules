
data "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
}

data "aws_iam_role" "crawler_role" {
  name = var.iam_role_name
}


resource "aws_glue_catalog_database" "catalog" {
  name = var.database_name

  create_table_default_permission {
    permissions = ["ALL"]

    principal {
      data_lake_principal_identifier = "IAM_ALLOWED_PRINCIPALS"
    }
  }
}


resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.catalog.name
  name          = "${var.database_name}_crawler"
  table_prefix  = var.crawler_tables_prefix

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  role = data.aws_iam_role.crawler_role.arn

  s3_target {
    path = "s3://${data.aws_s3_bucket.s3_bucket.id}/${var.s3_bucket_prefix}"
  }

  # Schedule every day:
  schedule = var.crawler_schedule
  configuration = jsonencode(
    {
      CrawlerOutput = {
        Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
        Tables     = { AddOrUpdateBehavior = "MergeNewColumns" }
      }
      Version = 1
    }
  )

  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${self.name}"
  }
}
