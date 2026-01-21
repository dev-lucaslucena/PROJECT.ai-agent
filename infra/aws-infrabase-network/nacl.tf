# Create a Network ACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-nacl"
  }
}

# Allow all inbound traffic
resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Allow all outbound traffic
resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate the NACL with the public subnets
resource "aws_network_acl_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  network_acl_id = aws_network_acl.main.id
}