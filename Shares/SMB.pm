#-*- Mode: perl; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
#
# Copyright (C) 2000-2001 Ximian, Inc.
#
# Authors: Hans Petter Jansson <hpj@ximian.com>
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

package Shares::SMB;

use Utils::File;

# --- share_export_smb_info; information on a particular SMB export --- #

sub gst_share_smb_info_set
{
  my ($info, $key, $value) = @_;
  
  if ($value eq "")
  {
    delete $info->{$key};
  }
  else
  {
    $info->{$key} = $value;
  }
}

sub gst_share_smb_info_get_name
{
  return $_[0]->{'name'};
}

sub gst_share_smb_info_set_name
{
  &gst_share_smb_info_set ($_[0], 'name', $_[1]);
}

sub gst_share_smb_info_get_point
{
  return $_[0]->{'point'};
}

sub gst_share_smb_info_set_point
{
  &gst_share_smb_info_set ($_[0], 'point', $_[1]);
}

sub gst_share_smb_info_get_comment
{
  return $_[0]->{'comment'};
}

sub gst_share_smb_info_set_comment
{
  &gst_share_smb_info_set ($_[0], 'comment', $_[1]);
}

sub gst_share_smb_info_get_enabled
{
  return $_[0]->{'enabled'};
}

sub gst_share_smb_info_set_enabled
{
  &gst_share_smb_info_set ($_[0], 'enabled', $_[1]);
}

sub gst_share_smb_info_get_browse
{
  return $_[0]->{'browse'};
}

sub gst_share_smb_info_set_browse
{
  &gst_share_smb_info_set ($_[0], 'browse', $_[1]);
}

sub gst_share_smb_info_get_public
{
  return $_[0]->{'public'};
}

sub gst_share_smb_info_set_public
{
  &gst_share_smb_info_set ($_[0], 'public', $_[1]);
}

sub gst_share_smb_info_get_write
{
  return $_[0]->{'write'};
}

sub gst_share_smb_info_set_write
{
  &gst_share_smb_info_set ($_[0], 'write', $_[1]);
}


# --- share_smb_table; multiple instances of share_smb_info --- #

sub smb_table_find
{
  my ($name, $shares) = @_;

  foreach $i (@$shares)
  {
    return $i if ($$i[0] eq $name)
  }

  return undef;
}

sub get_distro_smb_file
{
  my ($smb_comb);

  my %dist_map =
  (
   "redhat-6.0"      => "redhat-6.2",
   "redhat-6.1"      => "redhat-6.2",
   "redhat-6.2"      => "redhat-6.2",
   
   "redhat-7.0"      => "debian-3.0",
   "redhat-7.1"      => "debian-3.0",
   "redhat-7.2"      => "debian-3.0",
   "redhat-7.3"      => "debian-3.0",
   "redhat-8.0"      => "debian-3.0",
   "redhat-9"        => "debian-3.0",
   "openna-1.0"      => "redhat-6.2",

   "mandrake-7.1"    => "redhat-6.2",
   "mandrake-7.2"    => "redhat-6.2",
   "mandrake-9.0"    => "debian-3.0",
   "mandrake-9.1"    => "debian-3.0",
   "mandrake-9.2"    => "debian-3.0",
   "mandrake-10.0"   => "debian-3.0",
   "mandrake-10.1"   => "debian-3.0",
   "mandrake-10.2"   => "debian-3.0",

   "debian-2.2"      => "debian-3.0",
   "debian-3.0"      => "debian-3.0",
   "debian-sarge"    => "debian-3.0",

   "suse-9.0"        => "debian-3.0",
   "suse-9.1"        => "debian-3.0",

   "turbolinux-7.0"  => "debian-3.0",
   
   "slackware-8.0.0" => "debian-3.0",
   "slackware-8.1"   => "debian-3.0",
   "slackware-9.0.0" => "debian-3.0",
   "slackware-9.1.0" => "debian-3.0",
   "slackware-10.0.0" => "debian-3.0",
   "slackware-10.1.0" => "debian-3.0",
   "slackware-10.2.0" => "debian-3.0",

   "gentoo"          => "debian-3.0",
   "vlos-1.2"        => "debian-3.0",

   "archlinux"       => "debian-3.0",

   "pld-1.0"         => "pld-1.0",
   "pld-1.1"         => "pld-1.0",
   "pld-1.99"        => "pld-1.0",
   "fedora-1"        => "debian-3.0",
   "fedora-2"        => "debian-3.0",
   "fedora-3"        => "debian-3.0",
   "rpath"           => "debian-3.0",

   "vine-3.0"        => "debian-3.0",
   "vine-3.1"        => "debian-3.0",

   "freebsd-5"       => "freebsd-5",
   "freebsd-6"       => "freebsd-5",
  );

  my %dist_tables =
  (
   "redhat-6.2" => "/etc/smb.conf",
   "debian-3.0" => "/etc/samba/smb.conf",
   "pld-1.0"    => "/etc/smb/smb.conf",
   "freebsd-5"  => "/usr/local/etc/smb.conf",
  );

  my $dist = $dist_map {$Utils::Backend::tool{"platform"}};
  return $dist_tables{$dist} if $dist;
  return undef;
}

sub get_share_info
{
  my ($smb_conf_name, $section) = @_;
  my @share;

  push @share, $section;
  push @share, &Utils::Parse::get_from_ini      ($smb_conf_name, $section, "path");
  push @share, &Utils::Parse::get_from_ini      ($smb_conf_name, $section, "comment");
  push @share, &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "available");
  push @share, &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "browsable") ||
               &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "browseable");
  push @share, &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "public")      ||
               &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "guest");
  push @share, &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "writable")    ||
               &Utils::Parse::get_from_ini_bool ($smb_conf_name, $section, "writeable");

  return \@share;
}

sub set_share_info
{
  my ($smb_conf_file, $share) = @_;
  my ($section);

  $section = shift (@$share);

  &Utils::Replace::set_ini        ($smb_conf_file, $section, "path",      shift (@$share));
  &Utils::Replace::set_ini        ($smb_conf_file, $section, "comment",   shift (@$share));
  &Utils::Replace::set_ini_bool   ($smb_conf_file, $section, "available", shift (@$share));
  &Utils::Replace::set_ini_bool   ($smb_conf_file, $section, "browsable", shift (@$share));
  &Utils::Replace::set_ini_bool   ($smb_conf_file, $section, "public",    shift (@$share));
  &Utils::Replace::set_ini_bool   ($smb_conf_file, $section, "writable",  shift (@$share));

  &Utils::Replace::remove_ini_var ($smb_conf_file, $section, "browseable");
  &Utils::Replace::remove_ini_var ($smb_conf_file, $section, "guest");
  &Utils::Replace::remove_ini_var ($smb_conf_file, $section, "writeable");
}

sub get_shares
{
  my ($smb_conf_file);
  my (@sections, @table, $share);

  $smb_conf_file = &get_distro_smb_file;

  # Get the sections.
  @sections = &Utils::Parse::get_ini_sections ($smb_conf_file);

  for $section (@sections)
  {
    next if ($section =~ /^(global)|(homes)|(printers)|(print\$)$/);
    next if (&Utils::Parse::get_from_ini_bool ($smb_conf_file, $section, "printable"));

    $share = &get_share_info ($smb_conf_file, $section);
    push @table, $share;
  }

  return \@table;
}

sub get
{
  my ($shares, $workgroup, $desc, $wins, $winsserver);

  $shares = &get_shares ();
  
  $workgroup = &Utils::Parse::get_from_ini ($smb_conf, "global", "workgroup");
  $smbdesc = &Utils::Parse::get_from_ini ($smb_conf, "global", "server string");
  $wins = &Utils::Parse::get_from_ini_bool ($smb_conf, "global", "wins support");
  $winsserver = &Utils::Parse::get_from_ini ($smb_conf, "global", "wins server");

  return ($shares, $workgroup, $smbdesc, $wins, $winsserver);
}

sub set_shares
{
  my ($smb_conf_file, $shares) = @_;
  my (@sections, $section, $share);

  # Get the sections.
  @sections = &Utils::Parse::get_ini_sections ($smb_conf_file);

  # remove deleted sections
  foreach $section (@sections)
  {
    next if ($section =~ /^(global)|(homes)|(printers)|(print\$)$/);
    next if (&Utils::Parse::get_from_ini_bool ($smb_conf_file, $section, "printable"));

    if (!&smb_table_find ($section, $shares))
    {
      Utils::Replace::remove_ini_section ($smb_conf_file, $section);
    }
  }

  for $share (@$shares)
  {
    &set_share_info ($smb_conf_file, $share);
  }
}

sub set
{
  my ($shares, $workgroup, $desc, $wins, $winsserver) = @_;
  my ($smb_conf_file);
  my (@sections, $export);

  $smb_conf_file = &get_distro_smb_file;

  &set_shares ($smb_conf_file, $shares);

  &Utils::Replace::set_ini ($smb_conf_file, "global", "workgroup", $workgroup);
  &Utils::Replace::set_ini ($smb_conf_file, "global", "server string", $desc);
  &Utils::Replace::set_ini_bool ($smb_conf_file, "global", "wins support", $wins);
  &Utils::Replace::set_ini ($smb_conf_file, "global", "wins server", ($wins) ? "" : $winsserver);
}

1;