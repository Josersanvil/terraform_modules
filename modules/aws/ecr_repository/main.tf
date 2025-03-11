resource "aws_ecr_repository" "repository" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "repository_policy" {
  repository = aws_ecr_repository.repository.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 5
        description  = "Keep 'latest' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "latest"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 6
        description  = "Keep 'production' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "production"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 7
        description  = "Keep 'development' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "development"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 8
        description  = "Keep 'staging' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "staging"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 9
        description  = "Keep 'lambda' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "lambda"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 10
        description  = "Keep 'stable' tagged images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = [
            "stable"
          ],
          countType   = "imageCountMoreThan"
          countNumber = 9999
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 20
        description  = "Delete old images"
        selection = {
          tagStatus   = "any"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      },
    ]
  })
}
