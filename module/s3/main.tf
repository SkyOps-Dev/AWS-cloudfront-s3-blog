resource "aws_s3_bucket" "mybucket" {
  bucket = var.s3.bucket
}
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = var.s3.status
  }
}
resource "aws_s3_bucket_website_configuration" "s3bucket_website" {
  bucket = aws_s3_bucket.mybucket.id
  index_document {
    suffix = var.s3.suffix
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.mybucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.oai_id}"]
    }
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.mybucket.arn]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.oai_id}"]
    }
  }
}
resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = var.s3.access_block
  block_public_policy     = var.s3.access_block
  ignore_public_acls      = var.s3.access_block
  restrict_public_buckets = var.s3.access_block
}



