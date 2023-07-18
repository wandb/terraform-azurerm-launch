# Terraform Azurerm Launch - Demonstration Modules

This folder contains demonstration modules for the `terraform-azurerm-launch` repository.

Specifically, these modules aim to serve as a guide or illustration on how one might use and implement modules using Terraform and AzureRM for the launch agent to be deployed to. It is crucial to note that the modules in this folder are for demonstration purposes only and are **not intended for production use**. 

Users should have an exsisting AKS Compute Cluster which may have serveral GPU or CPU node groups attached and a queue should be configured for each Node Group looking to be leveradged by launch.

## Contents

This folder consists of two main modules:

1. **AKS Module:** This module outlines the creation of an Azure Kubernetes Service (AKS) cluster.
2. **Networking Module:** This module provides an example of setting up network resources in Azure, such as virtual networks and private subnets.

You can find these modules used in an example at `terraform-azurerm-launch/example/private-launch-demonstration-only`.

## Usage

To see these modules in action, navigate to the `private-launch-demonstration-only` directory in the `terraform-azurerm-launch/example` dirrectory. Here, you'll find example Terraform configurations that make use of these demonstration modules.

## Important Notice

As previously mentioned, these modules are purely for demonstration purposes. They serve to provide examples of module creation and usage in Terraform using the Azure provider. They do not represent best practices for production-ready infrastructure and should not be used in such environments without significant modification and validation.

**Note:** This README assumes you are familiar with Terraform and the AzureRM provider. If you're new to Terraform, please start by reviewing the [official Terraform documentation](https://www.terraform.io/docs/index.html).
