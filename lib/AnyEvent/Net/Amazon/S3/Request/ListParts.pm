package AnyEvent::Net::Amazon::S3::Request::ListParts;

# ABSTRACT: List the parts in a multipart upload.
# VERSION

use strict;
use warnings;

use Module::AnyEvent::Helper::Filter -as => __PACKAGE__,
        -target => substr(__PACKAGE__, 10),
        -transformer => 'Net::Amazon::S3';

1;
