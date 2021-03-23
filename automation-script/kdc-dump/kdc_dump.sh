#!/bin/bash
#################################
# Created by : EIS Devops
# Date : 2019-06-11
# Type: KDC DiskSpace Alert
#################################
set -e
# Get config.
.  $( dirname "${BASH_SOURCE[0]}" )/kdc_dump.app
.  $( dirname "${BASH_SOURCE[0]}" )/kdc_dump.functions

if [[ "$DISKSPACEROOT" -ge $DISKSPACEROOT_SIZE ]] || [[ "$DISKSPACEEBS" -ge $DISKSPACEEBS_SIZE ]]; then
	mail_send "KDC-Master-Disk-Space-Status" "KDC-Master Disk-Space is almost full at $(date +%x_%r)"
	exit 1
else
	mail_grp
	dump_start
	bkp_dump
	compress_dbfile
	dump_slave
	remove_oldfile
fi
