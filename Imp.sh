#!/bin/bash
clear
f1=`ifconfig | grep addr: | head -n1 | cut -d ':' -f2 | cut -d '.' -f2`
f2=`ifconfig | grep addr: | head -n1 | cut -d ':' -f2 | cut -d '.' -f3`
ht=`hostname`

#Usuario Digita o Ip final da impressora
echo "Digite o numero do IP Final da Impressora"
read ip

echo
#verifica se o ip digitado ja existe ou não 
ip01=`grep $ip /etc/cups/printers.conf | grep -i socket | cut -d '.' -f4 | cut -c 1-2`


if [ "$ip" = "$ip01"  ];then
#se ja existe, o aparece a mensagem e realiza um teste de ping
        echo -e " IP que foi Digitado já existente \n"
        sleep 1

        echo -e " Realizando Teste de ping no ip 10.$f1.$f2.$ip\n "
        if ! ping -c3 10.$f1.$f2.$ip  >/dev/null; then
        sleep 1
#se nao estiver na rede aparece a mensagem e não executa o comando.
        echo -e " Impressora Não esta na Rede \n "

        else
#Caso o ip digitado esteja disponivel aparece a mensagem e executa o comando 
        echo -e " Impressora na Rede \n "

     fi

        else

        sleep 1
        
#Mensagem que aparece na tela 
        echo -e " Configurando IP $ip em $ht \n "
#teste de ping que verifica o ip digitado pelo usuario, caso estiver para cadastro testa o ip antes de executar o comando.
        echo -e " Realizando Teste de ping no ip 10.$f1.$f2.$ip \n "

             if ! ping -c3 10.$f1.$f2.$ip  >/dev/null; then

        echo -e " Impressora Não esta na Rede \n "

        else

        echo -e " Impressora na Rede\n"
#se ip responder na rede ele ira executar o comando abaixo com de acordo com a maquina
	imp=`grep -i hp /etc/cups/printers.conf | head -n1 | cut -d ' ' -f2 | cut -c 1-2`
	fil=`hostname | cut -c 4-6`

	if [ "$imp" = "hp" ];then 
        
lpadmin -p hp"$fil"_"$ip" -v socket://10.$f1.$f2.$ip:9100 -P  /usr/share/cups/model/manufacturer-PPDs/kyocera/Kyocera_Mita_FS-1000+_en.ppd.gz -E
	
	sleep 5 
	
		echo -e " Impressora hp"$fil"_"$ip" configurada  \n "
	else

lpadmin -p hp$fil -v socket://10.$f1.$f2.$ip:9100 -P  

	sleep 5
		echo -e " Impressora hp$fil configurada  \n "
        fi
    fi
fi
