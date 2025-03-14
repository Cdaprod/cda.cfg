# Dotfiles Backup and Management

---

## Quick Use of install_script.sh bash script

`curl -sSL https://raw.githubusercontent.com/Cdaprod/cda.cfg/main/install_dotfiles.sh | bash`

or

`RUN curl -sSL https://raw.githubusercontent.com/Cdaprod/cda.cfg/main/install_dotfiles.sh | bash`

---

## dotfiles output instructions

```bash
❯ cdactl help
Usage: cdactl [command] [options]
Commands:
  1. network    - Manage network connections
  2. ssh        - SSH into devices
  3. update     - Update system packages
  4. backup     - Manage backups
  5. monitor    - Monitor system resources
  6. dotfiles   - Manage dotfiles (init, add, pull, sync)
  7. cred       - Manage credentials (store, retrieve)
  8. help       - Show this help message
❯ cdactl dotfiles help
✖ Invalid dotfiles command. Use: init, add, pull, or sync
❯ cdactl dotfiles add ~/.oh-my-zsh/
``` 

---

## Overview
This guide outlines the process for backing up and managing dotfiles across multiple servers using a Git bare repository. It enables seamless synchronization and version control of your configuration files.

## Prerequisites
- Git installed on your server.
- A private remote Git repository (e.g., on GitHub, GitLab, Bitbucket).
- Basic familiarity with Git commands.

## Initialization
1. **Creating a Bare Git Repository**: 
   Initialize a bare Git repository in your home directory to manage dotfiles.
   
   ```bash
   git init --bare $HOME/.cfg
   ```

2. **Setting Up Git Alias**:
   Create an alias for managing dotfiles with Git.
   
   ```bash
   alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
   echo "alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
   ```

3. **Remote Repository Setup**:
   Link your local repository to the remote private repository.
   
   ```bash
   cfg remote add origin https://github.com/yourusername/dotfiles.git
   ```

4. **Branching Strategy** (Optional):
   For different server configurations, create unique branches.
   
   ```bash
   cfg checkout -b server-specific-branch
   ```

---

## Usage
After setting up, manage your dotfiles as follows:

1. **Adding Dotfiles**:
   Add your dotfiles to the repository.
   
   ```bash
   cfg add .bashrc
   cfg commit -m "Add bashrc"
   ```

2. **Syncing Across Servers**:
   Push and pull changes to and from the remote repository.
   
   ```bash
   cfg push origin server-specific-branch
   cfg pull origin server-specific-branch
   ```

## Best Practices
- Regularly update and commit changes to your dotfiles.
- Keep sensitive data like SSH keys secure and avoid pushing them to public repositories.
- Review changes before pushing to avoid conflicts across different servers.

## Troubleshooting
- Ensure Git is properly configured and authenticated on each server.
- Check network connectivity if you encounter issues pushing to or pulling from the remote repository.

---

Replace "yourusername" with your actual GitHub/GitLab/Bitbucket username, and adjust the branch names and file paths as per your configuration. This README acts as a comprehensive guide for managing your dotfiles across multiple servers, ensuring a streamlined and efficient process.

---

Maintaining your dotfiles using a bare Git repository is an efficient way to track and synchronize them across different systems. Your script outlines the basic steps for setting this up. Here’s a breakdown of what each step does:

1. **Initialize a Bare Git Repository for Dotfiles:**
   ```bash
   git init --bare $HOME/.cfg
   ```
   This command creates a bare Git repository in the `.cfg` directory within your home directory. A bare repository contains no working or checked-out source files, making it suitable for dotfiles management.

2. **Add 'cfg' Alias to the Shell Configuration:**
 
   ```bash
   echo "alias cfg='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> $HOME/.zshrc
   ```
   This line adds an alias named `cfg` to your `.zshrc` file. This alias simplifies Git commands within the repository, allowing you to use `cfg` instead of the full Git command. 

3. **Reload the Shell Configuration:**
 
   ```bash
   source $HOME/.zshrc
   ```
   This command reloads your `.zshrc` file, enabling the newly added `cfg` alias in your current session.

4. **Add the Remote Repository:**
  
   ```bash
   cfg remote add origin https://github.com/Cdaprod/cda.cfg.git
   ```
   Here, you're using the `cfg` alias to add a remote repository URL to your bare repository. This sets up the connection to your GitHub repository where your dotfiles will be stored.

5. **Optional: Checkout a Specific Branch:**

   ```bash
   # cfg checkout linode/cdaprod-config
   ```
   If you have a specific branch in your dotfiles repository that you want to use, you can check it out using this command. Uncomment it and modify the branch name as necessary.

### Steps to Follow:

1. **Run the Script**: This will set up everything as outlined.

2. **Add Your Dotfiles to the Repository:**
   After setting up, you can start adding your dotfiles to the repository. For example:
   
   ```bash
   cfg add .zshrc
   cfg commit -m "Add .zshrc"
   ```

3. **Push the Changes to the Remote Repository:**

   ```bash
   cfg push origin master
   ```
   Replace `master` with your branch name if different.

4. **Replicating on Another System:**
   To replicate your environment on another system, clone the repository using:
   
   ```bash
   git clone --bare https://github.com/Cdaprod/cda.cfg.git $HOME/.cfg
   alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
   cfg checkout
   ```

Remember to replace the URLs and branch names with those specific to your setup. This method is powerful for managing and synchronizing your dotfiles across various environments.