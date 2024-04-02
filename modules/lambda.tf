data "archive_file" "lambda_function_file" {
  type = "zip"
  source_file = "functions/consumer.py"
  output_path = "functions/consumer.zip"
}

resource "aws_lambda_function" "KP1Consumer" {
  function_name = "KP1Consumer"
  handler       = "consumer.lambda_handler"
  role          = aws_iam_role.KP1ConsumerRole.arn
  runtime       = "python3.8"

  environment {
    variables = {
      STAGE = "dev"
    }
  }

  filename         = data.archive_file.lambda_function_file.output_path  # Use the output_path of the archive_file data source
  source_code_hash = data.archive_file.lambda_function_file.output_base64sha256
}

resource "aws_lambda_event_source_mapping" "KP1ConsumerMapping" {
  event_source_arn  = aws_kinesis_stream.KP1DataStream.arn
  function_name     = aws_lambda_function.KP1Consumer.arn
  starting_position = "LATEST"
  batch_size        = 10
  maximum_batching_window_in_seconds = 10
}