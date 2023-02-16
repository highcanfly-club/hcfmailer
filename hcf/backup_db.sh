#!/bin/bash
pg_dump -d $LISTMONK_db__database -h $LISTMONK_db__host -U $LISTMONK_db__user > /listmonk/backups/backup.sql