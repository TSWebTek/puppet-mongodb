#!/bin/sh
# file managed by puppet

umask 0037
PATH="/bin:/sbin:/usr/bin:/usr/sbin"
FULL_HOUR="${1:-*}"
MONGODIR="/var/lib/mongodb"
FULL_FILE="all-databases"
BKPDIR="/var/backups/mongodb"

# Installed ?
if [ -e /usr/bin/mongodump ]; then
  if [ -d $MONGODIR ]; then

    # Remove the existing full backup if the hour is right
    if [ "$FULL_HOUR" = "*" ] || [ "$(date +%H)" -eq "$FULL_HOUR" ]; then
      if [ -e "$BKPDIR/$FULL_FILE.tgz" ]; then
        rm "$BKPDIR/$FULL_FILE.tgz"
      fi
    fi

    if [ ! -e "$BKPDIR/$FULL_FILE.tgz" ]; then
      # Create full backup
      cd $BKPDIR
      rm -rf "$BKPDIR/dump"
      mongodump > /dev/null && nice -19 tar -cf - dump | gzip -9 > "$FULL_FILE.tgz"
      rm -rf "$BKPDIR/dump"
    fi

  else
    # no databases to backup ? no problem
    exit 0
  fi
else
  echo "mongodump missing.  Are you sure this cron must run?"
  exit 1
fi
