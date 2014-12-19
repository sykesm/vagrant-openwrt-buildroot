#!/bin/sh -x

DEFAULT_DNS_SEARCH=""

# Dynamic servers-conf pointed to by /etc/dnsmasq.conf
DNSMASQ_SERVERS_FILE=/var/run/vpn-dns.conf

touch $DNSMASQ_SERVERS_FILE
chown root.root $DNSMASQ_SERVERS_FILE
chmod 644 $DNSMASQ_SERVERS_FILE

setup_dns() {
	local dns
	local servers

	echo "# Interface $TUNDEV" >> $DNSMASQ_SERVERS_FILE

	[ -n "$CISCO_SPLIT_DNS" ] || CISCO_SPLIT_DNS=${DEFAULT_DNS_SEARCH}
	for dns in $PROTO_DNS; do
		echo "server=/$(echo ${CISCO_SPLIT_DNS} | sed -e 's%,%/%g')/$dns" >> $DNSMASQ_SERVERS_FILE
	done

	# Reload dnsmasq servers config file
	killall -HUP dnsmasq
}

cleanup_dns() {
	sed -i $DNSMASQ_SERVERS_FILE -e "/^# Interface $TUNDEV/,/^#/{/^# Interface $TUNDEV/{s/.*//g}/^#/!{s/.*//g}}" -e '/^$/ d'

	killall -HUP dnsmasq
}


case "$1" in
	"setup")
		cleanup_dns
		setup_dns
		;;

	"teardown")
		cleanup_dns
		;;

	*)
		exit 1
		;;
esac

exit 0
