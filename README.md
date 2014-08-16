# NAME

AnyEvent::Net::Amazon::S3 - Use the Amazon S3 - Simple Storage Service

# VERSION

version v0.03.0.60

# SYNOPSIS

    # Can be used as same as Net::Amazon::S3
    use AnyEvent::Net::Amazon::S3;
    my $aws_access_key_id     = 'fill me in';
    my $aws_secret_access_key = 'fill me in too';

    my $s3 = AnyEvent::Net::Amazon::S3->new(
        {   aws_access_key_id     => $aws_access_key_id,
            aws_secret_access_key => $aws_secret_access_key,
            retry                 => 1,
        }
    );

    # a bucket is a globally-unique directory
    # list all buckets that i own
    my $response = $s3->buckets;
    foreach my $bucket ( @{ $response->{buckets} } ) {
        print "You have a bucket: " . $bucket->bucket . "\n";
    }

    # create a new bucket
    my $bucketname = 'acmes_photo_backups';
    my $bucket = $s3->add_bucket( { bucket => $bucketname } )
        or die $s3->err . ": " . $s3->errstr;

    # or use an existing bucket
    $bucket = $s3->bucket($bucketname);

    # store a file in the bucket
    $bucket->add_key_filename( '1.JPG', 'DSC06256.JPG',
        { content_type => 'image/jpeg', },
    ) or die $s3->err . ": " . $s3->errstr;

    # store a value in the bucket
    $bucket->add_key( 'reminder.txt', 'this is where my photos are backed up' )
        or die $s3->err . ": " . $s3->errstr;

    # list files in the bucket
    $response = $bucket->list_all
        or die $s3->err . ": " . $s3->errstr;
    foreach my $key ( @{ $response->{keys} } ) {
        my $key_name = $key->{key};
        my $key_size = $key->{size};
        print "Bucket contains key '$key_name' of size $key_size\n";
    }

    # fetch file from the bucket
    $response = $bucket->get_key_filename( '1.JPG', 'GET', 'backup.jpg' )
        or die $s3->err . ": " . $s3->errstr;

    # fetch value from the bucket
    $response = $bucket->get_key('reminder.txt')
        or die $s3->err . ": " . $s3->errstr;
    print "reminder.txt:\n";
    print "  content length: " . $response->{content_length} . "\n";
    print "    content type: " . $response->{content_type} . "\n";
    print "            etag: " . $response->{content_type} . "\n";
    print "         content: " . $response->{value} . "\n";

    # delete keys
    $bucket->delete_key('reminder.txt') or die $s3->err . ": " . $s3->errstr;
    $bucket->delete_key('1.JPG')        or die $s3->err . ": " . $s3->errstr;

    # and finally delete the bucket
    $bucket->delete_bucket or die $s3->err . ": " . $s3->errstr;

# DESCRIPTION

This module provides the same interface as [Net::Amazon::S3](https://metacpan.org/pod/Net::Amazon::S3).
In addition, some asynchronous methods returning AnyEvent condition variable are added.

Note: This is the legacy interface, please check out
[AnyEvent::Net::Amazon::S3::Client](https://metacpan.org/pod/AnyEvent::Net::Amazon::S3::Client) instead.

# METHODS

All [Net::Amazon::S3](https://metacpan.org/pod/Net::Amazon::S3) methods are available.
In addition, there are the following asynchronous methods.
Arguments of the methods are identical as original but return value becomes [AnyEvent](https://metacpan.org/pod/AnyEvent) condition variable.
You can get actual return value by calling `shift->recv()`.

- buckets\_async
- add\_bucket\_async
- delete\_bucket\_async
- list\_bucket\_async
- list\_bucket\_all\_async
- add\_key\_async
- get\_key\_async
- head\_key\_async
- delete\_key\_async

# TESTING

The following description is extracted from [Net::Amazon::S3](https://metacpan.org/pod/Net::Amazon::S3).
They are all applicable to this module.

Testing S3 is a tricky thing. Amazon wants to charge you a bit of
money each time you use their service. And yes, testing counts as using.
Because of this, the application's test suite skips anything approaching
a real test unless you set these three environment variables:

- AMAZON\_S3\_EXPENSIVE\_TESTS

    Doesn't matter what you set it to. Just has to be set

- AWS\_ACCESS\_KEY\_ID

    Your AWS access key

- AWS\_ACCESS\_KEY\_SECRET

    Your AWS sekkr1t passkey. Be forewarned that setting this environment variable
    on a shared system might leak that information to another user. Be careful.

# SEE ALSO

- [AnyEvent::Net::Amazon::S3::Bucket](https://metacpan.org/pod/AnyEvent::Net::Amazon::S3::Bucket)
- [Net::Amazaon::S3](https://metacpan.org/pod/Net::Amazaon::S3) - Based on it as original.
- [Module::AnyEvent::Helper](https://metacpan.org/pod/Module::AnyEvent::Helper) - Used by this module. There are some description for needs of \_async methods.

# AUTHOR

Yasutaka ATARASHI <yakex@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Yasutaka ATARASHI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
