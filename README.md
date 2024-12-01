# Cloud-Design

Purpose of this project was to learn about he IaC and deploy Kubernetes HA cluster with Load balancing and monitoring to AWS using Terraform.

### Usage

You need Terraform, AWS cli logged in, Kubectl installed

`terraform init`

`terraform apply`

`aws eks update-kubeconfig --name staging-cloud-design --region eu-north-1`

`kubectl apply -f sec/`

`kubectl apply -f manifests/ -R`

`kubectl get svc --all` - to get the ip of an instance

change the address and post

`curl -X POST -H "Content-Type: application/json" -d '{"title":"TOP GUN", "description":"Story of a fighter pilot"}' http://a6c255d236ebd425eb7b59916a
c96e02-170234924.eu-north-1.elb.amazonaws.com:3000/movies`

check your input

`curl http://a6c255d236ebd425eb7b59916a
c96e02-170234924.eu-north-1.elb.amazonaws.com:3000/movies`
 

### Explanation

Starting with [network](terraf/3-network.tf) creation
* Creating Virtual Private Network with CIDR block "10.0.0.0/16". DNS support and host names are needed for resolving domain names within the VPC. 

* Setting up internet gateway for the VPC, allows instances to connect to the internet. It's associated with previously created VPC.

* Allocating Elastic IP for the Network Address Translation Gateway. Domain is set to "vpc", indicating that the EIP is for use within the VPC.

* Creating that NAT gateway using the allocated EIP. It's placed in a public subnet. the `depends_on` attribute ensures that the NAT gateway is created only after the Internet Gateway is available.

Adding [subnets](terraf/4-subnet.tf) to VPC

* 2 private and 2 public subnets, each are in different availability zones which is good practice when some zones are going to have issues. Ideally they would be geographically different places too.

* Instances launched in public subnet are automatically receiving public ip addresses. 

* All subnets are tagged for use with external load balancers and Kubernetes integration.

Defining [Route tables](terraf/5-routes.tf)

* Private subnet route table for VPC includes a route that directs all outbound traffic (0.0.0.0/0) through the NAT gateway. This ensures that instances in private subnet can access the internet while keeping their private IP addresses hidden. 

* Public subnet route table for VPC includes route for all outbound traffic through Internet Gateway. Allows instances to connect directly to the internet. 

* Four last blocks are associating defined route tables with specific subnets.

Creating [Elastic Kubernetes Service](terraf/6-eks.tf)

* Creating IAM role and policy for EKS and attaching it.

* `role_arn` attribute assigns IAM role to the EKS cluster which is necessary for the cluster to interact with other AWS services.

* `vpc_config` configures the networking settings for the EKS cluster.
* `endpoint_private_access` attribute is set to false, meaning that the cluster's API server endpoint is not accessible from within the VPC.

* `endpoint_public_access` attribute is set to true, allowing the API server endpoint to be accessible over the internet.

* `subnet_ids` specifies that the EKS cluster is deployed in the private subnets.

* `access_config` configures the access settings for the EKS cluster. The `authentication_mode` is set to "API", indicating that API-based authentication is used. The `bootstrap_cluster_creator_admin_permissions` is granting the cluster creator administrative permissions during the bootstrap process.

* `depends_on` ensures that the creation of the cluster depends on the successful attachment of an IAM role policy.

Defining [node groups](terraf/7-nodes.tf)

* Starting with attaching necessary policies for the node group.

* Creating node group "general". Listing subnets where the nodes are being deployed. `capacity_type` is set so that the nodes will be "ON_DEMAND" instances. Instance types are set t3.medium, which have 17 available pod slots.

* `scaling_config` allows the node group to scale up or down based on the work load.

* `update_config` specifies the update settings for the node group, meaning that during updates, a maximum of one node can be unavailable at any given time.

* `depends_on` IAM role policies again.

* `lifecycle` block includes `ignore_changes` attribute, which instructs Terraform to ignore changes to the desired_size attribute of the `scaling_config`. This allows external changes to the desired size without causing a difference in the `Terraform plan` command.

Defining [IAM roles](terraf/8-iam.tf) for accessing and managing cluster.

