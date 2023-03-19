#!/bin/bash
#Block List Tools (http://shorl.com/fovogretopiga)
#From the maintainer of Combined Privacy Block Lists (https://github.com/bongochong/CombinedPrivacyBlockLists)
#License: CPAL-1.0 (https://github.com/bongochong/CombinedPrivacyBlockLists/blob/master/LICENSE.md)
	read -r -p "Are you ready to update your proxy auto-configuration block list? [y/N] " response
	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
	then
echo "Cleaning up & Fetching PAC lists..."
mkdir -p ~/BLT/pac
cd ~/BLT/pac
rm -f pac-* *.pac
echo "Changed working directory and cleaned up old data. Now downloading new lists."
wget -nv -O 1.pac "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/NoFormatting/MD-ID-Fork.txt"
wget -nv -O 2.pac "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/disconnect_consolidated.txt"
wget -nv -O 3.pac "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
wget -nv -O 4.pac "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext"
wget -nv -O 5.pac "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/piperun-hosts.txt"
wget -nv -O 6.pac "https://raw.githubusercontent.com/bongochong/CombinedPrivacyBlockLists/master/ABP2Hosts/adguard_mobile-hosts.txt"
echo "Lists Downloaded. Now parsing..."
sed -i '$a\' *.pac
sed -e '$s/$/\n/' -s *.pac | sed "s/#.*$//" | sed "s/\s\.*$//" | sed "/^$/d" | sed "/^Site$/d" | sed "s/\(.*\)/\L\1/" | pcregrep -f ~/BLT/parsing/tld-filter.dat | sed "s/\t\+/ /g" | sed "s/^127.0.0.1 //g" | sed "s/^0.0.0.0 //g" | sed "s/^::1 //g" | sed "s/^:: //g" | pcregrep -v -f ~/BLT/parsing/pacpatterns.dat | sed "/@/d" | sed "/ /d" | sed "/\[/d" | sed "/\]/d" | sed "/\//d" | sed -e "s/^www\.//g" -e "/^admob\./d" -e "/^adsrv\./d" -e "/^adserv\./d" -e "/^adserve\./d" -e "/^adserver\./d" -e "/^adserving\./d" -e "/^banner\./d" -e "/^banners\./d" -e "/^errorhelpline24x7/d" -e "/^pcmssecuresetup24x7/d" -e "/^pcsecuresafety24x7/d" -e "/^pcsecuresetup24x7/d" -e "/^notoficationdelivery/d" -e "/^prostitutki/d" -e "/^daionlineas/d" -e "/^dateasesonlineas/d" -e "/^datematefor/d" -e "/^datemenowfor/d" -e "/^fuckfreenow/d" -e "/^fuckmenow/d" -e "/^23moesian/d" -e "/^aa-metrics\./d" -e "/^account-info0/d" -e "/^adobeanalytics\./d" -e "/^care887/d" -e "/^masihtidur-shoes/d" -e "/^org77supp/d" -e "/^ressstauww/d" -e "/^solution23/d" -e "/^suppamz2/d" -e "/^sux71a37/d" -e "/^warningprotokol/d" -e "/^winb2as/d" -e "/^wixclwardwual/d" -e "/^zxcsaxb/d" -e "/^data-44a005f23c\./d" -e "/^data-452782981b\./d" -e "/^data-497ecca600\./d" -e "/^data-60d896f23d\./d" -e "/^data-67f17c94f0\./d" -e "/^data-6dde45f576\./d" -e "/^data-84a0f3455d\./d" -e "/^data-908fd409d9\./d" -e "/^data-c5740f79ff\./d" -e "/^data-c5925d7d99\./d" -e "/^data-f1e447fbcf\./d" -e "/^data-f59db3288b\./d" -e "/^data-fdf4690b14\./d" -e "/^adbmetrics\./d" -e "/^adbsmetrics\./d" -e "/^adsapi\./d" -e "/^adsatt\./d" -e "/^advrts\./d" -e "/^track\.msadcenter\./d" -e "/^active-cupo-/d" -e "/^aumento-cupo-/d" -e "/^avance-cupo-/d" -e "/^copris7-/d" -e "/^hayalanphezor-/d" -e "/^hvgjgj-/d" -e "/^noticesumartyas-/d" -e "/^xyxyxyx/d" | pcregrep -i -v -f ~/BLT/parsing/wildcardwhitelist.dat | perl -p -e 's/^/\./' | ./cmprdmns.pl | sed -e 's/^\.//g' | sort -f | uniq -i > pac-uniq.txt
cp pac-uniq.txt pac-pre.txt
cp pac-pre.txt pac-pre2.txt
sed -i "s/^/*./" pac-pre.txt
cat pac-pre.txt pac-pre2.txt > pac-wew.txt
perl -i -pe 'chomp if eof' pac-wew.txt
sed -e 's/^/shExpMatch(host, "/' -e 's/$/") ||/' pac-wew.txt > pac-lad.txt
sed "2r pac-lad.txt" < ~/BLT/parsing/pactemplate.txt > pac-done.js
sed -i "1s/^/\/\/ **** $(date -u)\n/" pac-done.js
perl -i -pe 'chomp if eof' pac-done.js
echo "Properly merged and formatted block lists into new PAC file."
# curl -T pac-done.js ftp://SERVER-AND-DIRECTORY-HERE --user USERNAME-HERE:PASSWORD-HERE
# echo "Successfully uploaded PAC to remote servers. We're done!"
rm -f *.pac *.txt
echo "~---_---_---~"
ls -lh ~/BLT/pac
echo "~---_---_---~"
paCount=$(grep -w "shExpMatch" -c ~/BLT/pac/pac-done.js)
echo "Your current PAC file contains $paCount unique entries..."
echo "~---_---_---~"
exit
	else
	echo "Alright, goodbye!"
	fi
exit
