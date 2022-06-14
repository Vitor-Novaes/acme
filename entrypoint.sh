#!/bin/bash
set -e

bundle exec rails db:create db:migrate
echo "PostgreSQL database has been created & migrated!"

# Remove a potentially pre-existing server.pid for Rails.
rm -f /acme/tmp/pids/server.pid

echo ""
echo "   .     '     ,"
echo "     _________"
echo "  _ /_|_____|_\ _"
echo "    '. \   / .'"
echo "      '.\ /.'"
echo "        '.'"
echo " "
echo ""
echo ""
bundle exec rails s -p 3000 -b 0.0.0.0
