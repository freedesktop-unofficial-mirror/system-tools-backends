#-*- Mode: perl; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

# DBus object for the network interfaces config
#
# Copyright (C) 2005 Carlos Garnacho
#
# Authors: Carlos Garnacho Parro  <carlosg@gnome.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

package IfacesConfig;

use Network::Ifaces;

use base qw(Net::DBus::Object);
use Net::DBus::Exporter ($Utils::Backend::DBUS_PREFIX);

my $OBJECT_NAME = "IfacesConfig";
my $OBJECT_PATH = "$Utils::Backend::DBUS_PATH/$OBJECT_NAME";

sub new
{
  my $class   = shift;
  my $service = shift;
  my $self    = $class->SUPER::new ($service, $OBJECT_PATH);

  bless $self, $class;

#  Utils::Monitor::monitor_files (&Users::Groups::get_files (),
#                                 $self, $OBJECT_NAME, "changed");

  return $self;
}

dbus_method ("get", [],
             [[ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string", "string", "int32", "string" ]],
              [ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "string", "string", "string", "int32", "int32", "string", "string", "int32", "int32", "int32", "int32" ]],
              [ "array", [ "struct", "string", "int32", "string", "string", "string", "string", "int32", "int32", "int32", "int32" ]]]);
dbus_method ("set",
             [[ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string", "string", "int32", "string" ]],
              [ "array", [ "struct", "string", "int32", "int32", "string", "string", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "string", "string" ]],
              [ "array", [ "struct", "string", "int32", "string", "string", "string", "int32", "int32", "string", "string", "int32", "int32", "int32", "int32" ]],
              [ "array", [ "struct", "string", "int32", "string", "string", "string", "string", "int32", "int32", "int32", "int32" ]]], []);

dbus_signal ("changed", []);

sub get
{
  my ($self) = @_;

  return &Network::Ifaces::get ();
}

sub set
{
  my ($self, @config) = @_;

  &Network::Ifaces::set ($config[0], $config[1], $config[2],
                         $config[3], $config[4], $config[5]);
}

1;