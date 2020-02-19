# :mailbox_closed: spf_list

List mailservers from spf by iterating over spf entries & includes.

Extended to allow for whitelisting and blacklisting of mailservers in postfix to speed up `postscreen` greylisting.

## Features

- [x] list mailservers from spf records
- [x] output blacklist entries for servers
- [x] output whitelist entries for servers

## Usage Example

Add domain to whitelist

    ./spf_permit.sh google.com >> /etc/postfix/postscreen_access.cidr

## Related Blog Posts

- [Extracting Mailserver List From SPF](https://equk.co.uk/2020/02/19/extracting-mailserver-list-from-spf)
- [Whitelisting Mailservers From SPF](https://equk.co.uk/2020/02/19/whitelisting-mailservers-from-spf)

## Postscreen

    The Postfix postscreen daemon provides additional protection against mail server overload.
    One postscreen process handles multiple inbound SMTP connections,
    and decides which clients may talk to a Postfix SMTP server process.
    By keeping spambots away, postscreen leaves more SMTP server processes available for legitimate clients,
    and delays the onset of server overload conditions.


### Whitelisting / Blacklisting domains based on SPF

using the default config

`/etc/postfix/main.cf`

        postscreen_access_list = permit_mynetworks,
            cidr:/etc/postfix/postscreen_access.cidr

add entries to `/etc/postfix/postscreen_access.cidr`

    # postscreen access list
    # A simple combined white/blacklist
    # Only "permit" and "reject" work on the RHS
    # This is a CIDR table, so see cidr_table(5) for LHS syntax

### Seperate Whitelist / Blacklist

you can create seperate files for blacklist / whitelist if desired eg:

`/etc/postfix/main.cf`

        postscreen_access_list = permit_mynetworks,
            cidr:/etc/postfix/postscreen_access.cidr,
            cidr:/etc/postfix/postscreen_reject.cidr,
            cidr:/etc/postfix/postscreen_permit.cidr

## Notes

    Classless Inter-Domain Routing (CIDR) is an expansion of the IP addressing system
    that allows for a more efficient and appropriate allocation of addresses.

# Contact

Website: https://equk.co.uk

Twitter: [@equilibriumuk](https://twitter.com/equilibriumuk)