Ansible managed softwares 

I have made my ansible project based upon standard directory structure as suggested in Ansible best practises documentation https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#content-organization. I use this project to setup a new machine starting from creating user and then installing softwares the ones I need. Here are the things you can do.

1. Setting up a user
   
   **ansible-playbook -i inventories/staging site.yml --tags "user" --extra-vars "operation=setup" --ask-pass**
1. Dropping a user
   
   **ansible-playbook -i inventories/staging site.yml --tags "user" --extra-vars "operation=drop" --ask-pass**
1. Install all softwares in one go.
   
   **ansible-playbook -i inventories/staging site.yml --extra-vars "operation=install" --ask-become-pass**
1. Uninstall all softwares in one go.
   
   **ansible-playbook -i inventories/staging site.yml --extra-vars "operation=un-install" --ask-become-pass**
1. Install a particular software (e.g. GIT)
   
   **ansible-playbook -i inventories/staging site.yml --tags "git" --extra-vars "operation=install" --ask-become-pass**

Whole project is divided into different roles. Let us start with describing each role in detail:
* __admin__
  
  This role can be used to create or drop a User on a remote machine.
  ```
  admin.yml
  ---------
  - name: Play book to setup/drop User
  hosts: administration
  become: yes
  roles:
   - admin
  ```
  If you will look it is using "administration" as hosts group. So all the hosts in inventory file with this group title will be  taken to create user. Since creating a user requires root permission that is why become is yes. This role has two yaml files user.yml and user-uninstall.yml. Please check user.yml to understand what it is doing. All the properties defined in __inventories/staging/group_vars/administration.yml__ will be used by user.yml scripts.
  
* __basic__

  This role can be used to install basic softwares e.g. vim, dnsutils and git. main.yml is importing the tasks from different   independent yaml scripts responsible to perform the task.
  Let us take an example of git.yml. This script first install GIT, And then setup github using public and private keys created   through github. Both the public and private keys of your account should be available in __basic/files/github__ folder. I created these through instructions mentioned in this URL https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent. And then added public key to github account.


* __tomcat__

This role can be used to install or un install tomcat from remote machine.
1. Firstly tomcat zip will be downloaded
2. Then it will be extracted in to a desired folder.
3. Then templates from template folder e.g. tomcat-users.xml will be copied into remote machine by replacing the placeholders with fact data available to ansible during run time taken from propertie file.
4. Then Tomcat service will be created by copying .service file into remote machine.
5. Then tomcat will be started
6. And a task will wait until it is not available.
7. AT last handlers from handler fiolder will be invoked to restart the tomcat if required when any change in template files is detected.

* __verify-softwares__

I created this role just to check the versions of installed softwares. Or check if it is installed or not to get a clear view which software is missing on remote machine.

* __Trobleshooting__

1. Since for each task ansible creates a new ssh task. So I have noticed that if you have shell script was not working as desired especially grep commands in shell script. So that is why I created a service file which invoke tomcat-init script.



  

