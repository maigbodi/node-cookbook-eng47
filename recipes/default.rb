#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
apt_update 'update_sources' do
  action :update
end

package 'nginx'

service 'nginx' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  notifies :restart, 'service[nginx]'
  action :delete
end

node.default['nodejs']['version'] = '12.14.1'
node.default['nodejs']['binary']['url'] = 'https://nodejs.org/dist/v12.14.1/node-v12.14.1.tar.xz'
node.default['nodejs']['binary']['checksum'] = '6cd28a5e6340f596aec8dbfd6720f444f011e6b9018622290a60dbd17f9baff6'
 
include_recipe 'nodejs::nodejs_from_binary'


nodejs_npm 'pm2'
