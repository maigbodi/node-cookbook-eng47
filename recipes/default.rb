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

execute 'add nodejs repo' do
  command 'curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -'
end
execute 'install nodejs' do
  command 'sudo apt-get install -y nodejs'
end



