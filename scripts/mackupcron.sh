#!/usr/bin/env bash

date >> /tmp/mackup-backup-cron.out
mackup --force backup >> /tmp/mackup-backup-cron.out

