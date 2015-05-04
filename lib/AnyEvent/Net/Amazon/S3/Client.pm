package AnyEvent::Net::Amazon::S3::Client;

# ABSTRACT: An easy-to-use Amazon S3 client with AnyEvent
# VERSION

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__, -target => 'Net::Amazon::S3::Client',
        -transformer => 'Net::Amazon::S3',
        -translate_func => [qw(@buckets create_bucket _send_request_raw _send_request _send_request_content _send_request_xpc)],
        -replace_func => [qw(_create request)]
;

1;

__END__

=for test_synopsis
no strict 'vars';
no warnings;

=head1 SYNOPSIS

  my $s3 = AnyEvent::Net::Amazon::S3->new(
    aws_access_key_id     => $aws_access_key_id,
    aws_secret_access_key => $aws_secret_access_key,
    retry                 => 1,
  );
  my $client = AnyEvent::Net::Amazon::S3::Client->new( s3 => $s3 );

  # list all my buckets
  # returns a list of L<AnyEvent::Net::Amazon::S3::Client::Bucket> objects
  my @buckets = $client->buckets;
  foreach my $bucket (@buckets) {
    print $bucket->name . "\n";
  }

  # create a new bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->create_bucket(
    name                => $bucket_name,
    acl_short           => 'private',
    location_constraint => 'US',
  );

  # or use an existing bucket
  # returns a L<AnyEvent::Net::Amazon::S3::Client::Bucket> object
  my $bucket = $client->bucket( name => $bucket_name );

=head1 DESCRIPTION

This module provides the same interface as L<Net::Amazon::S3::Client>.
In addition, some asynchronous methods returning AnyEvent condition variable are added.

WARNING: Original L<Net::Amazon::S3::Client> says that it is an early release of the Client classes, the APIs
may change.

=head1 METHODS

All L<Net::Amazon::S3::Client> methods are available.
In addition, there are the following asynchronous methods.
Arguments of the methods are identical as original but return value becomes L<AnyEvent> condition variable.
You can get actual return value by calling C<shift-E<gt>recv()>.

=for :list
= buckets_async
= create_bucket_async

=for Pod::Coverage bucket bucket_class

=head1 SEE ALSO

=for :list
* L<AnyEvent::Net::Amazon::S3>
* L<Net::Amazaon::S3::Client> - Based on it as original.
* L<Module::AnyEvent::Helper> - Used by this module. There are some description for needs of _async methods.
