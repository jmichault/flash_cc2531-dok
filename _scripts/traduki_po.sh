#!/usr/bin/env sh
#################################################################
# skripto por aŭtomate traduki frazojn sen traduko en po-dosieron
#################################################################

src=eo

#FIC=locale/en/LC_MESSAGES/motioneye.po
FIC=$1
BASEDIR=`dirname $0`
dst=`grep "^\"Language: .*\\n\"$" $FIC|sed "s/^\"Language: //;s/.n\"$//"`

cat $FIC|awk -v src=$src -v dst=$dst '{
  if ( CONTMSG==1 && substr($1,1,1) != "\"")
  {
    CONTMSG=0;
  }
  if ($1 == "msgid")
  {
    MSGID=substr($0,7);
    if(MSGID=="\"\"")
      CONTMSG=1;
  }
  else if ( CONTMSG==1 && substr($1,1,1) == "\"")
  {
    MSGID=MSGID $0;
  }
  else if ($1 == "msgstr")
  {
    if($2 != "\"\"" || MSGID == "\"\"")
    {
      print ("msgid " MSGID);
      print $0;
    }
    else
    {
      if(MATTER == "lang")
      {
        print ("msgid " MSGID);
        printf("msgstr \"" dst "\"\n");
      }
      else if(MATTER == "layout")
      {
        print ("msgid " MSGID);
        print ("msgstr " MSGID);
      }
      else if(MATTER == "lang-ref")
      {
        print ("msgid " MSGID);
        print ("msgstr " MSGID);
      }
      else
      {
        print ("#, fuzzy");
        print ("msgid " MSGID);
        printf("msgstr \"");
        MSG=system("_scripts/traduko.sh " src " " dst " " MSGID )
        printf("\"\n");
      }
      MATTER=""
    }
  }
  else if (substr($0,1,28) == "#. type: YAML Front Matter: ")
  {
    MATTER=substr($0,29);
    print $0;
  }
  else
  {
    print $0;
  }
}' >$FIC.$$
mv $FIC $FIC.old
mv $FIC.$$ $FIC
