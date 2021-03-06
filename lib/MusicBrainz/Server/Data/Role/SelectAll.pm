package MusicBrainz::Server::Data::Role::SelectAll;
use MooseX::Role::Parameterized;

parameter 'order_by' => (
    isa => 'ArrayRef',
    default => sub { ['id'] }
);

role
{
    requires '_columns', '_table', '_dbh', '_new_from_row', '_type';

    my $params = shift;

    method '_get_all_from_db' => sub {
        my ($self, $p) = @_;
        my $query = "SELECT " . $self->_columns .
            " FROM " . $self->_table .
            " ORDER BY " . (join ", ", @{ $p->order_by });
        $self->query_to_list($query);
    };

    method '_delete_all_from_cache' => sub {
        my $self = shift;
        $self->c->cache->delete($self->_type . ":all");
    };

    # Clear cached data if the list of all entities has changed.
    after 'insert' => sub { shift->_delete_all_from_cache; };
    after 'update' => sub { shift->_delete_all_from_cache; };
    after 'delete' => sub { shift->_delete_all_from_cache; };
    after 'merge' => sub { shift->_delete_all_from_cache; };

    method 'get_all' => sub
    {
        my $self = shift;
        my $key = $self->_type . ":all";

        my $cache = $self->c->cache($self->_type);
        my $all = $cache->get($key);

        return @$all if $all;

        my @all = $self->_get_all_from_db($params);
        $cache->set($key, \@all);

        return @all;
    };

    method 'sort_in_forms' => sub { 0 };
};

no Moose::Role;
1;

=head1 COPYRIGHT

Copyright (C) 2009 Oliver Charles
Copyright (C) 2011 MetaBrainz Foundation

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=cut
