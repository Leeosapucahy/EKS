resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/21"

  tags = {
    Name = "mp_leo"
  }
}

####################################################################

# A

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id

  route_table_id = aws_route_table.router_public.id

}


resource "aws_route_table_association" "private_app_a" {
  subnet_id = aws_subnet.private_app_a.id

  route_table_id = aws_route_table.router_private_a.id

}

resource "aws_route_table_association" "private_db_a" {
  subnet_id = aws_subnet.private_db_a.id

  route_table_id = aws_route_table.router_private_a.id

}

##########################################################################

# REDES

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "mp_leo"
  }

}

resource "aws_eip" "nat2" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "mp_leo"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "mp_leo"
  }
}

resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.nat.id #ELASTIC IP 1
  subnet_id     = aws_subnet.public_a.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_nat_gateway" "nat_gw_c" {
  allocation_id = aws_eip.nat2.id #ELASTIC IP 2
  subnet_id     = aws_subnet.public_c.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "mp_leo"
  }
}

# ROTA PÚBLICA
resource "aws_route_table" "router_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "mp_leo"
  }
}

# ROTA PRIVADA
resource "aws_route_table" "router_private_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_a.id
  }

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_route_table" "router_private_c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_c.id
  }

  tags = {
    Name = "mp_leo"
  }
}
#####################################################################


# C

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_subnet" "private_app_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_subnet" "private_db_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "mp_leo"
  }
}

resource "aws_route_table_association" "public_c" {
  subnet_id = aws_subnet.public_c.id

  route_table_id = aws_route_table.router_public.id

}

resource "aws_route_table_association" "private_app_c" {
  subnet_id = aws_subnet.private_app_c.id

  route_table_id = aws_route_table.router_private_c.id

}

resource "aws_route_table_association" "private_db_c" {
  subnet_id = aws_subnet.private_db_c.id

  route_table_id = aws_route_table.router_private_c.id

}