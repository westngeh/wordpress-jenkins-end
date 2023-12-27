provider "aws" {
  region = "us-east-1"
}

# Define the EBS CSI driver
module "ebs_csi_driver" {
  source = "terraform-aws-modules/eks/aws//modules/ebs-csi-drivers"

  cluster_name = "myapp-eks-cluster"
}
data "aws_iam_policy_document" "eks_nodes" {
  source_json = <<JSON
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume"
        ],
        "Resource": "*"
      }
    ]
  }
  JSON
}

resource "aws_iam_role_policy_attachment" "eks_nodes" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "your-worker-node-role-name"
}

resource "aws_iam_role_policy" "eks_nodes_custom" {
  name   = "eks_nodes_custom"
  role   = "your-worker-node-role-name"
  policy = data.aws_iam_policy_document.eks_nodes.json
}