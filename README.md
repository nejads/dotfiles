# Sorosh's dotfiles

This repository includes my configuration files, settings and shows how I setup and maintain my Mac.

> [TL;DR: Invest time learning to configure your machine and automate processes, you'll get that time back ten fold.](https://code.tutsplus.com/tutorials/setting-up-a-mac-dev-machine-from-zero-to-hero-with-dotfiles--net-35449)

### Command to install all packages on a new Macos machine

Sign in to iCloud and sync the settings folder, then
Running setup.sh install following:

- Install Homebrew from [brew.sh](https://brew.sh)
- Clone dotfiles repository from [github](https://github.com/nejads/dotfiles)
- Install the following formulae:
  ```
  brew install ansible python3
  ```

### Run all the roles

After setup, run all playbooks

```
ansible-playbook playbooks/bootstrap.yaml
```

### Run specific roles by tag

```
ansible-playbook playbooks/bootstrap.yaml --tags zsh
```

### Inspiration and credits:

- [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Sam Hosseini dotfiles](https://github.com/sam-hosseini/dotfiles/)

## Manual Setup

### Alfred

You can find Alfred setting in icloud under directory ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/. There is a file with the name Alfred.alfredpreferences.
Import this file into Alfred, more details can be found at https://www.alfredapp.com/help/advanced/sync/
