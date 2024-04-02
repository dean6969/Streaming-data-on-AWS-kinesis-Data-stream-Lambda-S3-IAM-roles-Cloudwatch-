resource "aws_s3_bucket" "KP1DataBucket" {
  bucket = "kp1-data-bucket"  
  acl = "private"
  force_destroy = true
}