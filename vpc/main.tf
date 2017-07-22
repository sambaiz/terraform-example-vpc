resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.vpc_name}"
    }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    count = "${length(var.public_subnet_cidr_blocks)}"
    cidr_block = "${var.public_subnet_cidr_blocks[count.index]}"
    availability_zone = "${element(var.public_subnet_availability_zones, count.index)}"
    map_public_ip_on_launch = true
    tags {
        Name = "${var.vpc_name}-public-${element(var.public_subnet_availability_zones, count.index)}"
    }
}

resource "aws_subnet" "private-subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    count = "${length(var.private_subnet_cidr_blocks)}"
    cidr_block = "${var.private_subnet_cidr_blocks[count.index]}"
    availability_zone = "${element(var.private_subnet_availability_zones, count.index)}"
    tags {
        Name = "${var.vpc_name}-private-${element(var.private_subnet_availability_zones, count.index)}"
    }
}

####################
# internet gateway #
####################

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags {
        Name = "${var.vpc_name}-public-route-table"
    }
}

resource "aws_route_table_association" "route-table-association" {
    count          = "${length(var.public_subnet_cidr_blocks)}"
    subnet_id      = "${element(aws_subnet.public-subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.public-route-table.id}"
}

###############
# nat gateway #
###############

resource "aws_eip" "nat" {
    vpc = true
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id     = "${aws_subnet.public-subnet.0.id}"
    depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "main-route-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.ngw.id}"
    }
    tags {
        Name = "${var.vpc_name}-main-route-table"
    }
}

resource "aws_main_route_table_association" "main-route-table-association" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.main-route-table.id}"
}
