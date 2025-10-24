# create one s3 bucket to store the files

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.ENV}-${var.bucket_name}"
    Environment = var.ENV
  }
}

#give bucket ownership

resource "aws_s3_bucket_ownership_controls" "mybucket_ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# set public access to true

resource "aws_s3_bucket_public_access_block" "mybucket_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#bucket acls

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_public_access_block.mybucket_access,aws_s3_bucket_ownership_controls.mybucket_ownership]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#upload objects

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "files/index.html"
  content_type = "text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "files/error.html"
  content_type = "text/html"
}


# S3 bucket Policy

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.mybucket.id
  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
    "Principal": "*",
        "Action": [ "s3:GetObject" ],
        "Resource": [
            "${aws_s3_bucket.mybucket.arn}/*"
        ]
        }
    ]
    }
    EOF
    }

resource "aws_s3_bucket_website_configuration" "mybucketconfig" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}