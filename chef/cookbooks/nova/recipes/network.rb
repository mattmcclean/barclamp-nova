#
# Cookbook Name:: nova
# Recipe:: network
#
# Copyright 2010, Opscode, Inc.
# Copyright 2011, Dell, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nova::config" 

nova_package("network")


# Crowbar uses the network node as the gateway in flat non-dhcp modes, add the
# firewall rule for UEC images to be able to fetch metadata info
unless (node[:nova][:network][:dhcp_enabled] || node[:nova][:network][:quantum_enabled])
  execute "iptables -t nat -A PREROUTING -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination #{node[:nova][:my_ip]}:8773"
end

