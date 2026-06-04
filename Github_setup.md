# 📘 Git + Auto Push Setup Guide (Ubuntu Server)

This guide provides simple steps to install Git, connect it to your GitHub account, and set up an automatic system that pushes your changes every 30 minutes.

---

## 🧰 Part 1: Basic Git Setup

### 1. Install Git
Update your server's package list and install Git.
```bash
sudo apt update
sudo apt install git -y
git --version
```

### 2. Clone Your Repository
Navigate to your home directory and download your project from GitHub.
```bash
cd ~
git clone git@github.com:USERNAME/REPO.git
cd REPO
```

### 3. Check Remote Connection
Verify which GitHub repository your local folder is linked to.
```bash
git remote -v
```

### 4. Change GitHub Repository (If Needed)
If you need to point your project to a different repository URL:
```bash
git remote set-url origin git@github.com:USERNAME/REPO.git
```

### 5. Check Current Branch
Check which branch you are currently working on (e.g., `main` or `master`).
```bash
git branch
```

### 6. Pull Latest Updates
Download the most recent changes from GitHub to your server.
```bash
git pull origin main
```

### 7. Manual Add, Commit, and Push
Use these commands to manually save and upload your work.
```bash
git add .
git commit -m "your message here"
git push origin main
```

### 8. Fix Git Identity Error
If you see an error about identity, set your global username and email.
```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### 9. Test SSH Authentication
Check if your server can successfully communicate with GitHub via SSH.
```bash
ssh -T git@github.com
```

### 10. Check Repo Status
See which files are modified or waiting to be committed.
```bash
git status
```

---

## 🤖 Part 2: Auto Push System (Cron Job)

This section helps you automate the backup process so your server stays synced with GitHub every 30 minutes.

### 11. Create the Auto-Push Script
Create a new script file using a text editor (like `nano`).
```bash
nano /root/git-auto-push.sh
```

**Paste the following content into the file:**
```bash
#!/bin/bash
cd /root/cybersecurity || exit
git add .
git diff --cached --quiet || git commit -m "Auto sync $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
```

### 12. Make Script Executable
Give the system permission to run the script.
```bash
chmod +x /root/git-auto-push.sh
```

### 13. Test the Script
Run the script manually to ensure it works without errors.
```bash
/root/git-auto-push.sh
```

### 14. Add Cron Job (Every 30 Minutes)
Open the system scheduler to automate the script.
```bash
crontab -e
```
**Add this line at the bottom of the file:**
```cron
*/30 * * * * /bin/bash /root/git-auto-push.sh >> /root/git-auto-push.log 2>&1
```

### 15. Verify Cron Jobs
Check the list of active scheduled tasks.
```bash
crontab -l
```

### 16. Check Logs
Check the log file to see the history of the auto-push activities or find errors.
```bash
cat /root/git-auto-push.log
```

---

## ⚠️ Important Behavior

| Action on Server | GitHub Result |
| :--- | :--- |
| **Create file** | 📤 Uploaded |
| **Modify file** | 🔄 Updated |
| **Delete file** | 🗑️ Deleted |

## 🧠 Summary
Your server is now:
- ✅ A **live mirror backup** of your GitHub repository.
- ✅ **Auto-syncing** every 30 minutes.
- ✅ A fully **automated deployment system**.
