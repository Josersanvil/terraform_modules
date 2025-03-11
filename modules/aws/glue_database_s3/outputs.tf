output "catalog_id" {
  value       = aws_glue_catalog_database.catalog.catalog_id
  description = "Id of the Glue catalog in which the database resides"
}

output "database_name" {
  value       = aws_glue_catalog_database.catalog.name
  description = "The name of the Glue catalog database"
}

output "crawler_name" {
  value = aws_glue_crawler.crawler.id
}

output "crawler_arn" {
  value = aws_glue_crawler.crawler.arn
}
