# AdmCloud
 
For ssh into the VM:

    ssh -i admcloud_key user@$(terraform output -raw public_ip_<VM Name>)

Exemplo:
    ssh -i admcloud_key monicaaaraujo_aa@$(terraform output -raw public_ip_teste1)


sudo apt-get install python3-pip