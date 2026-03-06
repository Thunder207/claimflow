#!/bin/bash
# ClaimFlow Quick Backup Script
# Usage: ./quick-backup.sh [description]

TIMESTAMP=$(date +%Y%m%d-%H%M)
DESCRIPTION="${1:-Manual backup}"

echo "🔄 Creating ClaimFlow backup: $TIMESTAMP"
echo "Description: $DESCRIPTION"

# Create backup directory if needed
mkdir -p LOCAL-LIBRARY/backups

# Backup all critical files
cp employee-dashboard.html LOCAL-LIBRARY/backups/employee-dashboard-$TIMESTAMP.html
cp admin.html LOCAL-LIBRARY/backups/admin-$TIMESTAMP.html
cp login.html LOCAL-LIBRARY/backups/login-$TIMESTAMP.html
cp app.js LOCAL-LIBRARY/backups/app-$TIMESTAMP.js
cp package.json LOCAL-LIBRARY/backups/package-$TIMESTAMP.json

# Log the backup
echo "" >> LOCAL-LIBRARY/change-log.txt
echo "$(date): $DESCRIPTION" >> LOCAL-LIBRARY/change-log.txt
echo "Backup created: $TIMESTAMP" >> LOCAL-LIBRARY/change-log.txt
echo "Files backed up: employee-dashboard.html, admin.html, login.html, app.js, package.json" >> LOCAL-LIBRARY/change-log.txt
echo "---" >> LOCAL-LIBRARY/change-log.txt

echo "✅ Backup complete: $TIMESTAMP"
echo "💾 Files saved to LOCAL-LIBRARY/backups/"
echo "📝 Change logged to LOCAL-LIBRARY/change-log.txt"
echo ""
echo "Next steps:"
echo "1. Make your changes locally"
echo "2. Test changes"
echo "3. Update current-stable if good"
echo "4. Git commit"
echo "5. Deploy to Render"