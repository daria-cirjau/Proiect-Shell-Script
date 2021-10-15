#Proiectul meu calculeaza impozitul si TVA-ul pentru firmele ale caror date sunt introduse de la tastatura. 
#Datele calculate sunt copiate in fisierul text corespunzator firmei.
#Fiecare fisier este plasat in folderul corespunzator tipului firmei: PFA sau SRL. 
#Orice folder care nu contine fisiere este sters.
#!/bin/bash
echo -n "Introduceti numarul de firme: "
read n
a="$n"
mkdir FIRME_PFA
mkdir FIRME_SRL
while [ "$a" -gt 0 ]
do
a=`expr $a - 1`
echo -n "Introduceti numele firmei: "
read name
touch $name.txt
echo -n "Introduceti tipul firmei (PFA/SRL): "
read text
echo -n "Introduceti venitul (vanzari/prestari servicii): "
read venit
tvac=$(echo "scale=2; 19*$venit/100" | bc -l) 
echo -n "Introduceti cheltuielile (achizitii): "
read chelt
tvad=$(echo "scale=2; 19*$chelt/100" | bc -l)
imp=0
if [ $venit -gt $chelt ] && [ $text == "PFA" ] 
then
imp=$(echo "scale=2; 10*($venit-$chelt)/100" | bc -l)
fi
if [ $venit -gt $chelt ] && [ $text == "SRL" ] 
then
imp=$(echo "scale=2; 16*($venit-$chelt)/100" | bc -l)
fi
echo "Impozit pentru $text $imp">>$name.txt
echo "TVA deductibila $tvad">>$name.txt
echo "TVA colectata $tvac">>$name.txt
if [ $venit -gt $chelt ] 
then 
tvap=$(echo "scale=2; 19*($venit-$chelt)/100" | bc -l)
echo "TVA de plata $tvap">>$name.txt
else tvar=$(echo "scale=2; 19*($chelt-$venit)/100" | bc -l)
echo "TVA de recuperat $tvar">>$name.txt
fi
if [ $text == "PFA" ]
then
mv $name.txt FIRME_PFA
fi
if [ $text == "SRL" ]
then
mv $name.txt FIRME_SRL
fi
done
z=$(ls FIRME_PFA | wc -l)
if [ "$z" -eq 0 ]
then
rm -d FIRME_PFA 
echo "FIRME_PFA a fost sters pentru ca nu contine niciun fisier"
else
echo "FIRME_PFA contine urmatoarele fisiere: "
ls FIRME_PFA
echo "Doriti sa vedeti continutul unui fisier?(DA/NU)"
read answ
while [ "$answ" == "DA" ]
do
echo "Introduceti numele fisierului: "
read nume
cd FIRME_PFA
chmod a+x $nume.txt
cat $nume.txt
cd
echo "Doriti sa vedeti continutul unui fisier?(DA/NU)"
read answ
done
fi
x=$(ls FIRME_SRL | wc -l)
if [ "$x" -eq 0 ]
then
rm -d FIRME_SRL
echo "FIRME_SRL a fost sters pentru ca nu contine niciun fisier"
else
echo "FIRME_SRL contine urmatoarele fisiere: "
ls FIRME_SRL
echo "Doriti sa vedeti continutul unui fisier?(DA/NU)"
read answ
while [ "$answ" == "DA" ]
do
echo "Introduceti numele fisierului: "
read nume
cd FIRME_SRL
chmod a+x $nume.txt
cat $nume.txt
cd
echo "Doriti sa vedeti continutul unui fisier?(DA/NU)"
read answ
done
fi