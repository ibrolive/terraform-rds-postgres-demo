# variables.tf
variable "region" {
     default = "us-east-1"
}
variable "primaryAvailabilityZone" {
     default = "us-east-1a"
}
variable "secondaryAvailabilityZone" {
     default = "us-east-1b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock1" {
    #public
    #default = "10.0.0.0/24"
    #private
    default = "10.0.1.0/24"
}
variable "subnetCIDRblock2" {
    #private
    default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
# end of variables.tf