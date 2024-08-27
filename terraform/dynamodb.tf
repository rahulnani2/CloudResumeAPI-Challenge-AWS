/* Terraform configuration to create dynamodb table
resource "aws_dynamodb_table" "cloudresume" {
    name = "cloudresume-viewstable"
    billing_mode = "PAY_PER_REQUEST
  attribute {
        name = "id"
        type = "S"
    }

    attribute {
        name = "views"
        type = "N"
    }
    hash_key = "id"
    global_secondary_index {
        name = "views_count_index"
        hash_key = "views"
        projection_type = "ALL"
    }

    tags = { 
       Name = "Cloud-Resume-Challenge"
    }

} */