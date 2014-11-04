#
#    Copyright (C) 2014 Niklaus Giger <niklaus.giger@member.fsf.org>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe 'hylafax::server' do
  let(:params) { {:ensure => true, :input_dir => '/my/input'} }
  context 'when running on Debian GNU/Linux' do
    it {
      should contain_package('hylafax-server').with_ensure(/present|installed|true/)
      should contain_file('/my/input').with({'ensure' => 'directory'})
    }
  end
end

describe 'hylafax::server' do
  let(:params) { {:ensure => true, :input_dir => '/my/input',
                 # :input_facl => "grw",
                 } }
  context 'passing input_dir and facl' do
    it {
      should contain_package('hylafax-server').with_ensure(/present|installed|true/)
      should contain_file('/my/input').with({'ensure' => 'directory'})
      should contain_file('/etc/hylafax/FaxDispatch').with_content(/cp/)
      should contain_file('/usr/local/sbin/fooacl')
      should contain_exec('concat_/usr/local/sbin/fooacl')
#      should contain_fooacl__conf('facl_/home/praxis/Eingang')
      should contain_fooacl__conf('facl_/my/input')
    }
  end
end

describe 'hylafax::server' do
  let(:params) { {:ensure => true, :modem_type => 'trendnet', :input_dir =>'/home/praxis/Eingang', :tty => "ACM0"} }
  context 'and passing tty' do
    it {
      should contain_package('hylafax-server').with_ensure(/present|installed|true/)
      should contain_file('/home/praxis/Eingang')
      should contain_file('/etc/hylafax/config.ACM0').with_content(/template\/trendnet.erb/)
    }
  end
end

describe 'hylafax::server' do
  let(:params) { {:ensure => true, :modem_type => 'us_robotics', :input_dir =>'/home/praxis/Eingang', :tty => "ACM1"} }
  context 'and passing tty' do
    it {
      should contain_package('hylafax-server').with_ensure(/present|installed|true/)
      should contain_file('/home/praxis/Eingang')
      should contain_file('/etc/hylafax/FaxDispatch').with_content(/ \/home\/praxis\/Eingang/)
      should contain_file('/etc/hylafax/config.ACM1').with_content(/template\/us_robotics.erb/)
    }
  end
end

describe 'hylafax::server' do
  let(:params) { {:ensure => false,} }
  context 'and passing tty' do
    it {
      should contain_package('hylafax-server').with_ensure(/false/)
      should_not contain_file('/home/praxis/Eingang')
      should_not contain_file('/etc/hylafax/FaxDispatch')
      should_not contain_file('/etc/hylafax/config.ACM1')
    }
  end
end
