
// クエリ結果保存先のs3バケット
resource "aws_s3_bucket" "athena-query-log-bucket" {
  bucket = "athena-query-log-himapopo"
}

// ワークグループ
resource "aws_athena_workgroup" "himapopo-workgroup" {
  name = "himapopo-workgroup"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = false

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena-query-log-bucket.bucket}/logs/"
    }
  }
}

// database 作成
resource "aws_athena_database" "waf-block-logs-database" {
  name   = "waf_block_logs"
  bucket = aws_s3_bucket.athena-query-log-bucket.id
}

// create tableクエリを保存
resource "aws_athena_named_query" "waf-logs-create-table" {
  name      = "waf_logs_create_table"
  database  = aws_athena_database.waf-block-logs-database.id
  query     = templatefile("../modules/athena/waf_block_logs_create_table_sql.tpl", {athena_database_name = aws_athena_database.waf-block-logs-database.id})
  workgroup = aws_athena_workgroup.himapopo-workgroup.id
}

