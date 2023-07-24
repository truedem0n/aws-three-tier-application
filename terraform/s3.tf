data "archive_file" "app" {
  type        = "zip"
  source_dir  = "../webserver"
  output_path = "../app.zip"
}


resource "aws_s3_object" "server" {
  bucket = module.templates.dev-bucket
  key    = "two_tier/app.zip"
  source = data.archive_file.app.output_path
  etag   = filemd5(data.archive_file.app.output_path)
}