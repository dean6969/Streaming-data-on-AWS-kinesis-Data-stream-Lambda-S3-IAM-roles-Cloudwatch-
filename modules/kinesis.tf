resource "aws_kinesis_stream" "KP1DataStream" {
  name             = "KP1DataStream"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

output "kinesis_stream_name" {
  description = "Kinesis stream name"
  value       = aws_kinesis_stream.KP1DataStream.name
}