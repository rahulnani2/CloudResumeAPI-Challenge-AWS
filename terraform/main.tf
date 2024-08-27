resource "aws_lambda_function" "viewcount" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256
    function_name = "viewcount"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "func.handler"
    runtime = "python3.11"
}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    
    assume_role_policy = jsonencode({
    "Version": "2012-10-17"
    "Statement": [
      {
        "Action" : "sts:AssumeRole"
         "Principal": {
            "Service": "lambda.amazonaws.com"
        }
        "Effect": "Allow",
        "Sid": ""
        },
    ]
})  
} 

resource "aws_iam_policy" "iam_policy_cloud_resume" {
    name = "aws_iam_policy_for_terraform_resume_project_policy"
    path = "/"
    description = "AWS IAM Policy for managing the resume project role"
    policy = jsonencode ({
        "Version" = "2012-10-17",
        "Statement" = [
            {
                "Action" = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                "Resource" : "arn:aws:logs:*:*:*",
                "Effect" : "Allow" 
            },
            {
               "Effect" : "Allow",
               "Action" : [
                 "dynamodb:UpdateItem",
                 "dynamodb:GetItem"
               ],
               "Resource" : "arn:aws:dynamodb:*:*:table/cloudresume-viewstable" 
            },
        ]
    })
    }

resource "aws_iam_role_policy_attachment" "resume-policy-attach" {
    role = aws_iam_role.iam_for_lambda.name
    policy_arn = aws_iam_policy.iam_policy_cloud_resume.arn
}


data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda"
    output_path = "${path.module}/packedlambda.zip" 
}

resource "aws_lambda_function_url" "funcurl" {
    function_name = aws_lambda_function.viewcount.function_name
    authorization_type = "NONE" 

    cors {
        allow_credentials = true
        allow_origins = ["https://resume.rahulonline.cloud"]
        allow_methods = ["*"]
        allow_headers = ["date", "keep-alive"]
        expose_headers = ["keep-alive", "date"]
        max_age        = 86400

    }
} 