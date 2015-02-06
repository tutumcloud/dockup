#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi
