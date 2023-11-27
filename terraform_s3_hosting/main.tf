
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  alias  = "acm_provider"
}




resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  # acl    = "public-read"
  # policy = file("policy.json")

  # website {
  #   index_document = "index.html"
  #   error_document = "404.html"
  # }
}

resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"

  website {
    redirect_all_requests_to = var.domain_name
  }
}


resource "aws_s3_account_public_access_block" "website_bucket" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
























































# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0"


#     }
#   }
# }


# module "template_files" {
#   source = "hashicorp/dir/template"

#   base_dir = "${path.module}/build"
# }



# provider "aws" {
#   region = var.aws_region
#   alias  = "acm_provider"
# }


# resource "aws_s3_bucket" "hosting_bucket" {
#   bucket = var.bucket_name
# }

# # resource "aws_s3_bucket_acl" "hosting_bucket_acl" {
# #   bucket = aws_s3_bucket.hosting_bucket.id
# #   acl    = "public-read"
# # }


# # resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
# #   bucket = aws_s3_bucket.hosting_bucket.id

# #   policy = jsonencode({
# #     "Version" : "2012-10-17",
# #     "Statement" : [
# #       {
# #         "Effect" : "Allow",
# #         "Principal" : "*",
# #         "Action" : "s3:GetObject",
# #         "Resource" : "arn:aws:s3:::${var.bucket_name}/*"
# #       }
# #     ]
# #   })
# # }

# # resource "aws_s3_bucket_website_configuration" "hosting_bucket_website_configuration" {
# #   bucket = aws_s3_bucket.hosting_bucket.id

# #   index_document {
# #     suffix = "index.html"
# #     website {
# #       index_document = "index.html"
# #       error_document = "404.html"

# #       website {
# #         redirect_all_requests_to = var.domain_nam
# #       }
# #     }
# #   }
# # }


# # resource "aws_s3_object" "hosting_bucket_files" {
# #   bucket = aws_s3_bucket.hosting_bucket.id

# #   for_each = module.template_files.files

# #   key          = each.key
# #   content_type = each.value.content_type

# #   source  = each.value.source_path
# #   content = each.value.content

# #   etag = each.value.digests.md5
# # }


# resource "aws_s3_bucket" "root_bucket" {
#   bucket = var.bucket_name
#   website {
#     index_document = "/index.html"
#     error_document = "index.html"
#   }
# }

# resource "aws_s3_bucket" "www_bucket" {
#   bucket = "www.${var.bucket_name}"
#   website {
#     redirect_all_requests_to = var.domain_name
#   }
# }
