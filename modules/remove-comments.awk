BEGIN {
   found=0;
}

{
   spos=index($0,"/*");
   epos=index($0,"*/");

   if(spos > 0 && epos ==0)
   {
      printf("%s\n",substr($0,1,spos-1));
      found=1;
   }
   else if(spos == 0 && epos >0)
   {
      found=0;
      if(length($0) != epos+1)
      {
         printf("%s\n",substr($0,epos+2));
      }
   }
   else if(spos > 0 && epos > 0)
   {
        printf("%s %s\n",substr($0,1,spos-1),substr($0,epos+2));
   }
   else if(found==0)
   {
       cpp_comment=index($0,"//");
       if(cpp_comment == 0)
       {
          print;
       }
       else
       {
          printf("%s\n",substr($0,1,cpp_comment-1));
       }
   }
}

END {
   if(found==1)
   {
       print "there is unmatched comment"
   }
}
