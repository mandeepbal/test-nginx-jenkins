#
# Cookbook Name:: test-nginx-jenkins
# Recipe:: default
#
# Copyright (C) 2015 Mandeep Bal
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when 'debian'
  execute 'apache_configtest' do
    command 'apt-get update'
  end
#when 'rhel'
#  package 'java-1.7.0-openjdk'
end

include_recipe "jenkins::java"
include_recipe "jenkins::master"
include_recipe "nginx-repo::default"


package "nginx" do
	action :install
end

template '/etc/nginx/conf.d/default.conf' do
  source 'virtual.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, "service[nginx]", :immediately
end

file '/etc/nginx/conf.d/example_ssl.conf' do
  action :delete
  notifies :restart, "service[nginx]", :immediately
end

service 'nginx' do
  action [:enable, :start]
end