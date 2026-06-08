resource "aws_servicecatalogappregistry_application" "this" {
  name        = "${var.project_name}-application"
  description = "Aplicação que engloba todos os recursos usados no projeto ${var.project_name}"

  tags = {
    Name    = "${var.project_name}-application"
    project = var.project_name
  }
}

resource "aws_resourcegroups_group" "this" {
  name        = "${var.project_name}-resources"
  description = "Grupo dinâmico que engloba todos os recursos do projeto ${var.project_name}"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]

      TagFilters = [
        {
          Key    = "project"
          Values = [var.project_name]
        }
      ]
    })
  }

  tags = {
    Name    = "${var.project_name}-resources"
    project = var.project_name
  }
}



resource "awscc_servicecatalogappregistry_resource_association" "this" {
  application   = aws_servicecatalogappregistry_application.this.id
  resource      = aws_resourcegroups_group.this.id
  resource_type = "RESOURCE_GROUP"
}